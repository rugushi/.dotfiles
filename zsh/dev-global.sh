#!/bin/zsh

DEV_BASE_NAME="dev-container"

dev-build() {
    docker build -t dev -f ~/.dotfiles/dev/Dockerfile ~/.dotfiles/dev
}

dev-run() {
    local RAW_DIR="${1:-$PWD}"
    local HOST_DIR=$(realpath "$RAW_DIR")
    local DIR_NAME=$(basename "$HOST_DIR")
    local KEY_PATH="$HOME/.ssh/id_dev_container"

    local BASE_PORT=2222
    local COUNTER=1

    local NAME="${DEV_BASE_NAME}-${DIR_NAME}-${COUNTER}"
    local PORT=$BASE_PORT

    while [ "$(docker ps -aq -f name=^/${NAME}$)" ] || lsof -i:"$PORT" >/dev/null 2>&1; do
        ((COUNTER++))
        NAME="${DEV_BASE_NAME}-${DIR_NAME}-${COUNTER}"
        PORT=$((BASE_PORT + (COUNTER - 1)))
    done

    if [ ! -f "$KEY_PATH" ]; then
        ssh-keygen -t ed25519 -f "$KEY_PATH" -N "" -q
    fi

    echo "Starting $NAME on port $PORT..."

    docker run -d --name "$NAME" -p "$PORT:22" \
        -v "$HOST_DIR:/workspace" \
        -v "$HOME/.local/share/opencode/auth.json:/root/.local/share/opencode/auth.json" \
        -w /workspace \
        dev:latest

    docker exec -u root "$NAME" bash -c "mkdir -p /root/.ssh && echo '$(cat ${KEY_PATH}.pub)' >> /root/.ssh/authorized_keys"

    echo "------------------------------"
    echo "Container: $NAME"
    echo "Port:      $PORT"
    echo "SSH:       dev-ssh $PORT"
    echo "------------------------------"
}

dev-list() {
    if [ -z "$(docker ps -aq --filter "name=^/${DEV_BASE_NAME}")" ]; then
        echo "No dev containers found."
        return 0
    fi

    echo "---------------------------------"
    docker ps -a --filter "name=^/${DEV_BASE_NAME}" \
        --format "table {{.Names}},{{.Status}},{{.Ports}}" | \
        sed -e "s/${DEV_BASE_NAME}-//g" \
            -e 's/-[0-9]\{1,2\}//g' \
            -e 's/0\.0\.0\.0://g' \
            -e 's/->22\/tcp//g' \
            -e 's/, [^,]*$//g' \
            -e 's/\[::\]://g' | \
        column -t -s ','
    echo "---------------------------------"

}

dev-ssh() {
    local PORT="${1:-2222}"

    ssh -i ~/.ssh/id_dev_container \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        root@localhost -p "$PORT"
}

dev-clean() {
    local TARGETS=$(docker ps -aq --filter "name=^/${DEV_BASE_NAME}")

    if [ -n "$TARGETS" ]; then
        echo "Destroying: $TARGETS"

        echo "$TARGETS" | xargs docker rm -f >/dev/null

        echo "Cleaned up all dev containers."
    else
        echo "No dev containers found."
    fi
}
