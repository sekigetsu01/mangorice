var sioyekMode;

function read(path) {
    try { return sioyek_api.read_file(path) || ''; } catch (e) { return ''; }
}

function start_mode() {
    var dir = sioyek_api.get_environment_variable('HOME') + '/.config/sioyek/';
    var prefs = read(dir + 'prefs_user.config');
    var mode = /^\s*default_dark_mode\s+1\b/m.test(prefs) ? 'dark' : 'normal';
    var m = prefs.match(/^\s*startup_commands\s+(.*)$/m);
    if (m) {
        m[1].split(';').forEach(function (c) {
            c = c.trim();
            if (c === 'toggle_dark_mode') mode = (mode === 'dark') ? 'normal' : 'dark';
            if (c === 'toggle_custom_color') mode = (mode === 'custom') ? 'normal' : 'custom';
        });
    }
    return mode;
}

function wal(n, fallback) {
    try {
        var json = JSON.parse(read(sioyek_api.get_environment_variable('HOME') + '/.cache/wal/colors.json'));
        var hex = json.colors['color' + n];
        if (/^#[0-9a-fA-F]{6}$/.test(hex)) return hex + 'ff';
    } catch (e) {}
    return fallback;
}

function set_labels() {
    if (sioyekMode === undefined) sioyekMode = start_mode();
    var dark = wal(0, '#1c1c1cff'), accent = wal(3, '#ffcc33ff');
    var onDark = sioyekMode !== 'normal';
    sioyek.setconfig_keyboard_select_background_color(onDark ? accent : dark);
    sioyek.setconfig_keyboard_select_text_color(onDark ? dark : accent);
    sioyek.setconfig_text_highlight_color((onDark ? accent : dark).slice(0, 7));
}

function switch_mode(which) {
    if (sioyekMode === undefined) sioyekMode = start_mode();
    if (which === 'dark') sioyek.toggle_dark_mode();
    else sioyek.toggle_custom_color();
    sioyekMode = (sioyekMode === which) ? 'normal' : which;
    set_labels();
}

function custom() { switch_mode('custom'); }
function labels() { set_labels(); }
