import SwiftUI
import AppKit
import UniformTypeIdentifiers

// MARK: - State

enum ConversionState {
    case idle
    case converting
    case success(character: String, outputPath: String, log: String)
    case failure(message: String, log: String)
}

// MARK: - Main View

struct ContentView: View {
    @State private var conversionState: ConversionState = .idle
    @State private var isDropTargeted = false
    @State private var progress: Double = 0
    @State private var statusLine = "Ready"
    @State private var outputDir: URL = {
        Bundle.main.bundleURL
            .deletingLastPathComponent()
            .appendingPathComponent("characters")
    }()
    @State private var miscSSF: URL? = nil

    // Path to the ssf2_converter binary — bundled inside Contents/MacOS/
    var converterBin: URL {
        Bundle.main.executableURL!
            .deletingLastPathComponent()
            .appendingPathComponent("ssf2_converter")
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            mainContent
        }
        .frame(width: 700, height: 520)
        .background(Color(nsColor: .windowBackgroundColor))
    }

    // MARK: Header

    var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("SSF2 → Fraymakers")
                    .font(.system(size: 20, weight: .semibold))
                Text("Character Converter")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 6) {
                miscSsfPicker
                outputDirPicker
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }

    var miscSsfPicker: some View {
        HStack(spacing: 8) {
            Text("misc.ssf:")
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
            if let misc = miscSSF {
                Text(misc.lastPathComponent)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.green)
                    .lineLimit(1)
                Button("✕") { miscSSF = nil }
                    .buttonStyle(.plain)
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            } else {
                Text("auto-detect")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .italic()
            }
            Button("Set") {
                let panel = NSOpenPanel()
                panel.allowedContentTypes = [UTType(filenameExtension: "ssf") ?? .data]
                panel.allowsMultipleSelection = false
                panel.prompt = "Select misc.ssf"
                if panel.runModal() == .OK, let url = panel.url {
                    miscSSF = url
                }
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
        }
    }

    var outputDirPicker: some View {
        HStack(spacing: 8) {
            Text("Output:")
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
            Text(outputDir.lastPathComponent)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .truncationMode(.middle)
                .frame(maxWidth: 160)
            Button("Change") {
                let panel = NSOpenPanel()
                panel.canChooseDirectories = true
                panel.canChooseFiles = false
                panel.canCreateDirectories = true
                panel.prompt = "Select Output"
                if panel.runModal() == .OK, let url = panel.url {
                    outputDir = url
                }
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
        }
    }

    // MARK: Main content

    @ViewBuilder
    var mainContent: some View {
        switch conversionState {
        case .idle:
            dropZone
        case .converting:
            convertingView
        case .success(let char, let path, let log):
            successView(character: char, outputPath: path, log: log)
        case .failure(let msg, let log):
            failureView(message: msg, log: log)
        }
    }

    // MARK: Drop Zone

    var dropZone: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                    isDropTargeted
                        ? Color.accentColor
                        : Color.secondary.opacity(0.3),
                    style: StrokeStyle(lineWidth: 2, dash: [8, 4])
                )
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isDropTargeted
                              ? Color.accentColor.opacity(0.08)
                              : Color.clear)
                )
                .animation(.easeInOut(duration: 0.15), value: isDropTargeted)

            VStack(spacing: 16) {
                Image(systemName: "arrow.down.doc.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(isDropTargeted ? Color.accentColor : Color.secondary)
                    .animation(.easeInOut(duration: 0.15), value: isDropTargeted)

                Text("Drop an SSF file here")
                    .font(.system(size: 18, weight: .medium))

                Text("or")
                    .foregroundStyle(.secondary)
                    .font(.system(size: 13))

                Button("Choose File…") { pickFile() }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
            }
        }
        .padding(32)
        .onDrop(of: [.fileURL], isTargeted: $isDropTargeted) { providers in
            handleDrop(providers: providers)
        }
    }

    // MARK: Converting View

    var convertingView: some View {
        VStack(spacing: 24) {
            Spacer()
            ProgressView(value: progress)
                .progressViewStyle(.linear)
                .frame(maxWidth: 480)
            Text(statusLine)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding(40)
    }

    // MARK: Success View

    func successView(character: String, outputPath: String, log: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 52))
                .foregroundStyle(.green)
            Text("Converted \(character)!")
                .font(.system(size: 20, weight: .semibold))
            Text(outputPath)
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .truncationMode(.middle)
                .frame(maxWidth: 480)

            ScrollView {
                Text(log)
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
            }
            .frame(maxWidth: .infinity, maxHeight: 160)
            .background(Color(nsColor: .textBackgroundColor))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.secondary.opacity(0.2)))

            HStack(spacing: 12) {
                Button("Show in Finder") {
                    NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: outputPath)
                }
                .buttonStyle(.bordered)
                Button("Convert Another") {
                    conversionState = .idle
                    progress = 0
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(32)
    }

    // MARK: Failure View

    func failureView(message: String, log: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 52))
                .foregroundStyle(.red)
            Text("Conversion Failed")
                .font(.system(size: 20, weight: .semibold))
            Text(message)
                .font(.system(size: 13))
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)

            ScrollView {
                Text(log.isEmpty ? "(no output)" : log)
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
            }
            .frame(maxWidth: .infinity, maxHeight: 160)
            .background(Color(nsColor: .textBackgroundColor))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.secondary.opacity(0.2)))

            Button("Try Again") {
                conversionState = .idle
                progress = 0
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(32)
    }

    // MARK: Actions

    func pickFile() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [UTType(filenameExtension: "ssf") ?? .data]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.prompt = "Convert"
        if panel.runModal() == .OK, let url = panel.url {
            startConversion(url: url)
        }
    }

    func handleDrop(providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first else { return false }
        provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { item, _ in
            guard let data = item as? Data,
                  let url = URL(dataRepresentation: data, relativeTo: nil) else { return }
            DispatchQueue.main.async {
                if url.pathExtension.lowercased() == "ssf" {
                    startConversion(url: url)
                }
            }
        }
        return true
    }

    func startConversion(url: URL) {
        // Auto-detect misc.ssf if not manually set
        if miscSSF == nil {
            let siblingMisc = url.deletingLastPathComponent().appendingPathComponent("misc.ssf")
            if FileManager.default.fileExists(atPath: siblingMisc.path) {
                miscSSF = siblingMisc
            }
        }

        conversionState = .converting
        progress = 0.05
        statusLine = "Starting…"

        let bin = converterBin.path
        let input = url.path
        let outDir = outputDir.path
        let miscPath = miscSSF?.path

        DispatchQueue.global(qos: .userInitiated).async {
            // Animate progress while running
            let steps: [(Double, String)] = [
                (0.15, "Reading SSF file…"),
                (0.30, "Parsing SWF…"),
                (0.50, "Extracting animations…"),
                (0.65, "Extracting images…"),
                (0.80, "Generating Fraymakers files…"),
                (0.92, "Writing output…"),
            ]

            // Check binary exists
            guard FileManager.default.fileExists(atPath: bin) else {
                DispatchQueue.main.async {
                    conversionState = .failure(
                        message: "Converter binary not found at:\n\(bin)",
                        log: ""
                    )
                }
                return
            }

            let process = Process()
            process.executableURL = URL(fileURLWithPath: bin)
            var args = [input, "--output", outDir]
            if let misc = miscPath {
                args += ["--misc-ssf", misc]
            }
            process.arguments = args

            let stdoutPipe = Pipe()
            let stderrPipe = Pipe()
            process.standardOutput = stdoutPipe
            process.standardError  = stderrPipe

            // Tick through progress steps while running
            var stepIdx = 0
            let timer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { _ in
                if stepIdx < steps.count {
                    let (prog, msg) = steps[stepIdx]
                    stepIdx += 1
                    DispatchQueue.main.async {
                        withAnimation(.easeInOut(duration: 0.4)) { progress = prog }
                        statusLine = msg
                    }
                }
            }
            RunLoop.main.add(timer, forMode: .common)

            do {
                try process.run()
                process.waitUntilExit()
                timer.invalidate()

                let stdoutData = stdoutPipe.fileHandleForReading.readDataToEndOfFile()
                let stderrData = stderrPipe.fileHandleForReading.readDataToEndOfFile()
                let stdout = String(data: stdoutData, encoding: .utf8) ?? ""
                let stderr = String(data: stderrData, encoding: .utf8) ?? ""
                let log = (stderr + stdout).trimmingCharacters(in: .whitespacesAndNewlines)

                let charName = url.deletingPathExtension().lastPathComponent
                let charOutputPath = outputDir.appendingPathComponent(charName).path

                DispatchQueue.main.async {
                    withAnimation(.easeInOut(duration: 0.3)) { progress = 1.0 }
                    if process.terminationStatus == 0 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            conversionState = .success(
                                character: charName,
                                outputPath: charOutputPath,
                                log: log
                            )
                        }
                    } else {
                        conversionState = .failure(
                            message: "Converter exited with code \(process.terminationStatus)",
                            log: log
                        )
                    }
                }
            } catch {
                timer.invalidate()
                DispatchQueue.main.async {
                    conversionState = .failure(message: error.localizedDescription, log: "")
                }
            }
        }
    }
}
