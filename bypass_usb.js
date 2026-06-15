Java.perform(function() {
    console.log("[*] Script de Frida inyectado correctamente.");
    
    var SettingsGlobal = Java.use('android.provider.Settings$Global');
    
    SettingsGlobal.getInt.overload('android.content.ContentResolver', 'java.lang.String', 'int').implementation = function(resolver, name, def) {
        
        if (name === 'adb_enabled') {
            console.log("[!] La app está verificando si el USB Debugging está encendido.");
            console.log("[!] ¡Hackeando la respuesta! Forzando retorno a 0 (Apagado)...");
            
            return 0; 
        }
        return this.getInt(resolver, name, def);
    };
});
