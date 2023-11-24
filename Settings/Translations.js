// Translations.js
.pragma library

var translations = {
    "en_US": {
        "Hello, World!": "Hello, World!",
        // Add more English translations
    },
    "fr_FR": {
        "Hello, World!": "Bonjour, le Monde!",
        // Add more French translations
    },
    "es_ES": {
        "Hello, World!": "¡Hola, Mundo!",
        // Add more Spanish translations
    },
    // Add translations for other languages
};

function translate(key, languageCode) {
    return translations[languageCode][key];
}
