import os
import subprocess

# Configuration
source_directory = './'
translations_directory = os.path.join(source_directory, 'i18n')
languages = ['ar', 'de', 'es', 'fr', 'it', 'ja', 'nb_NO', 'en']
lupdate_path = '/usr/lib64/qt5/bin/lupdate'

# Specific group directories to process
groups = ['Settings', 'Gauges']

# Files that don't fall into groups
individual_files = [
    'AnalogInputs.qml', 'BrightnessPopUp.qml', 'ConsultRegs.qml', 
    'ExBoardAnalog.qml', 'Intro.qml', 'Laptimecontainer.qml', 
    'main.qml', 'OBDPIDS.qml', 'SerialSettings.qml'
]

i18n_files = []

def process_group(group_name):
    """Process a specific group directory, generating a .ts file for each language."""
    group_path = os.path.join(source_directory, group_name)
    # List all QML files in the group directory
    qml_files = [file for file in os.listdir(group_path) if file.endswith('.qml')]
    qml_files_full_path = [os.path.join(group_path, file) for file in qml_files]

    for lang in languages:
        ts_file = os.path.join(translations_directory, f"{group_name.lower()}_{lang}.ts")
        # Construct the command with all QML files explicitly listed
        command = [lupdate_path] + qml_files_full_path + ['-ts', ts_file]
        i18n_files.append(f"{group_name.lower()}_{lang}")
        print(f"Executing: {' '.join(command)}")
        subprocess.run(command)

def process_individual_files():
    """Process individual .qml files in the source directory, generating a .ts file for each."""

    for file_name in individual_files:
        base_name, _ = os.path.splitext(file_name)
        qml_file = os.path.join(source_directory, file_name)
        for lang in languages:
            ts_file = os.path.join(translations_directory, f"{base_name}_{lang}.ts")
            command = [lupdate_path, qml_file, '-ts', ts_file]
            i18n_files.append(f'{base_name}_{lang}')
            print(f"Executing: {' '.join(command)}")
            subprocess.run(command)

if __name__ == "__main__":
    os.makedirs(translations_directory, exist_ok=True)
    
    for group in groups:
        process_group(group)
    process_individual_files()
            
    with open('./i18n/translations.pri', 'w') as file:        
        file.write(f"LANGUAGES = {' '.join(languages)}\n")

        file.write("""

# For each language, compile the .ts files into a single .qm file
for(lang, LANGUAGES) {
    TS_FILES = $$files(*_$${lang}.ts)
    QM_FILE = $${lang}.qm

    message("command : lrelease $$TS_FILES -qm $$QM_FILE")
    # Define a custom target for each language
    system(lrelease $$TS_FILES -qm $$QM_FILE)|error("Failed to process translations for" $${lang})
}                   
""")

    with open('./i18n/translations.qrc', 'w') as file:
        file.write('<RCC>\n')
        file.write('    <qresource prefix="/i18n">\n')
        for lang in languages:
            file.write(f'        <file>{lang}.qm</file>\n')
        file.write('    </qresource>\n')
        file.write('</RCC>\n')
