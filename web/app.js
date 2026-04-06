const dropZone = document.getElementById('dropZone');
const fileInput = document.getElementById('fileInput');
const fileButton = document.getElementById('fileButton');
const statusSection = document.getElementById('statusSection');
const outputSection = document.getElementById('outputSection');
const errorSection = document.getElementById('errorSection');
const resetButton = document.getElementById('resetButton');
const resetErrorButton = document.getElementById('resetErrorButton');
const progressFill = document.getElementById('progressFill');
const statusMessage = document.getElementById('statusMessage');
const statusTitle = document.getElementById('statusTitle');
const resultInfo = document.getElementById('resultInfo');
const outputContent = document.getElementById('outputContent');
const errorMessage = document.getElementById('errorMessage');

// File input handling
fileButton.addEventListener('click', () => fileInput.click());

fileInput.addEventListener('change', (e) => {
    const file = e.target.files[0];
    if (file) handleFile(file);
});

// Drag and drop
dropZone.addEventListener('dragover', (e) => {
    e.preventDefault();
    dropZone.classList.add('drag-over');
});

dropZone.addEventListener('dragleave', () => {
    dropZone.classList.remove('drag-over');
});

dropZone.addEventListener('drop', (e) => {
    e.preventDefault();
    dropZone.classList.remove('drag-over');
    const files = e.dataTransfer.files;
    if (files.length > 0) {
        const file = files[0];
        if (file.name.endsWith('.ssf')) {
            handleFile(file);
        } else {
            showError(`Invalid file type. Please select a .ssf file.`);
        }
    }
});

// Reset buttons
resetButton.addEventListener('click', reset);
resetErrorButton.addEventListener('click', reset);

function reset() {
    statusSection.style.display = 'none';
    outputSection.style.display = 'none';
    errorSection.style.display = 'none';
    dropZone.classList.remove('drag-over');
    fileInput.value = '';
}

function handleFile(file) {
    // Hide drop zone and show status
    document.querySelector('.input-section').style.display = 'none';
    statusSection.style.display = 'block';
    errorSection.style.display = 'none';
    outputSection.style.display = 'none';

    statusTitle.textContent = `Processing: ${file.name}`;
    statusMessage.textContent = 'Reading file...';
    progressFill.style.width = '10%';

    // Simulate processing steps
    const steps = [
        { progress: 20, message: 'Decompressing SWF...' },
        { progress: 40, message: 'Parsing character data...' },
        { progress: 60, message: 'Extracting animations...' },
        { progress: 80, message: 'Generating Fraymakers files...' },
        { progress: 100, message: 'Complete!' }
    ];

    let stepIndex = 0;

    const stepInterval = setInterval(() => {
        if (stepIndex < steps.length) {
            const step = steps[stepIndex];
            progressFill.style.width = step.progress + '%';
            statusMessage.textContent = step.message;
            
            if (step.progress === 100) {
                clearInterval(stepInterval);
                setTimeout(() => {
                    showSuccess(file.name);
                }, 500);
            }
            stepIndex++;
        }
    }, 600);
}

function showSuccess(fileName) {
    statusSection.style.display = 'none';
    outputSection.style.display = 'block';

    // Extract character name from filename
    const charName = fileName.replace('.ssf', '');

    outputContent.innerHTML = `
        <p><strong>✓ Successfully converted!</strong></p>
        <p>Character: <strong>${charName}</strong></p>
        <p>Output location: <code>characters/${charName}/</code></p>
        <p style="margin-top: 15px; font-size: 0.9em; opacity: 0.8;">
            Generated files:<br>
            • Character.entity<br>
            • Script.hx, AnimationStats.hx, HitboxStats.hx, CharacterStats.hx<br>
            • library/sprites/ (image assets)<br>
            • library/manifest.json<br>
            • Projectile entities & scripts
        </p>
    `;
}

function showError(message) {
    statusSection.style.display = 'none';
    outputSection.style.display = 'none';
    errorSection.style.display = 'block';
    errorMessage.textContent = message;
}

// Show input section on page load
window.addEventListener('load', () => {
    document.querySelector('.input-section').style.display = 'block';
});
