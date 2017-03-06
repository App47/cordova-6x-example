cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "id": "com.app47.plugin.App47",
        "file": "plugins/com.app47.plugin/www/app47.js",
        "pluginId": "com.app47.plugin",
        "clobbers": [
            "window.app47"
        ]
    }
];
module.exports.metadata = 
// TOP OF METADATA
{
    "cordova-plugin-whitelist": "1.3.1",
    "com.app47.plugin": "3.0"
};
// BOTTOM OF METADATA
});