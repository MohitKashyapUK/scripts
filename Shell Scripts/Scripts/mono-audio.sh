#!/bin/bash

# Run this script using this command:
# curl -fsSL https://raw.githubusercontent.com/MohitKashyapUK/scripts/refs/heads/main/Shell%20Scripts/Scripts/mono-audio.sh | bash

set -e

mkdir -p ~/.config/pipewire/pipewire.conf.d
CONFIG_FILE="$HOME/.config/pipewire/pipewire.conf.d/mono-playback.conf"
if [[ ! -f "$CONFIG_FILE" ]]; then
    cat > "$CONFIG_FILE" <<'EOF'
context.modules = [
    { name = libpipewire-module-loopback
        args = {
            node.description = "Mono Output"
            capture.props = {
                node.name      = "mono_output"
                media.class    = "Audio/Sink"
                audio.position = [ MONO ]
            }
            playback.props = {
                node.name      = "playback.mono_output"
                audio.position = [ MONO ]
                node.passive   = true
            }
        }
    }
]
EOF
fi

mkdir -p ~/.config/wireplumber/wireplumber.conf.d
cat > ~/.config/wireplumber/wireplumber.conf.d/50-mono-default.conf <<'EOF'
monitor.alsa.rules = [
  {
    matches = [
      { { "node.name", "matches", "mono_output" } }
    ],
    actions = {
      update-props = {
        priority.driver = 1000
        priority.session = 1000
      }
    }
  }
]
EOF

echo "🔧 Restarting PipeWire & WirePlumber..."
systemctl --user restart pipewire pipewire-pulse wireplumber

echo "✅ Mono Output is now the default audio sink."
echo "⚠️  Agar aapko mono audio na aaye to **Settings → Sound** mein ja kar 'Mono Output' ko manually select kar lein."
