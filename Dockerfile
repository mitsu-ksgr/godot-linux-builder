FROM debian:11-slim

ARG GODOT_VERSION=4.6


Run apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    scons \
    pkg-config \
    libx11-dev libxcursor-dev libxinerama-dev libxi-dev libxrandr-dev \
    libfontconfig1 libasound2-dev libpulse-dev \
    libgl1-mesa-dev \
    ca-certificates wget unzip git python3 \
    && rm -rf /var/lib/apt/lists/*


# Install godot
WORKDIR /godot
RUN wget https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-stable/Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip \
    && unzip Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip \
    && mv Godot_v${GODOT_VERSION}-stable_linux.x86_64 /usr/local/bin/godot \
    && chmod +x /usr/local/bin/godot \
    && rm Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip

# Download export templates.
# Support: Linux, Windows
RUN mkdir -p /root/.local/share/godot/export_templates/${GODOT_VERSION}.stable
RUN wget -O export_templates.tpz https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-stable/Godot_v${GODOT_VERSION}-stable_export_templates.tpz \
    && unzip export_templates.tpz \
    && rm templates/android* \
    && rm templates/ios* templates/macos.zip \
    && rm templates/web* \
    && rm export_templates.tpz \
    && mv templates/* /root/.local/share/godot/export_templates/${GODOT_VERSION}.stable/ \
    && rm -rf templates


WORKDIR /build

