LANGUAGES = ar de es fr it ja nb_NO en


# For each language, compile the .ts files into a single .qm file
for(lang, LANGUAGES) {
    TS_FILES = $$files(*_$${lang}.ts)
    QM_FILE = $${lang}.qm

    message("command : lrelease $$TS_FILES -qm $$QM_FILE")
    # Define a custom target for each language
    system(lrelease $$TS_FILES -qm $$QM_FILE)|error("Failed to process translations for" $${lang})
}                   
