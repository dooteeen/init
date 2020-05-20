post_hook_vscode() {
    code --list-extensions 2>&1 | grep -q code-settings-sync \
        || code --install-extension Shan.code-settings-sync
}

