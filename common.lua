local module = {}
module.Channel = {
    -- 心跳包
    HEARTBEAT = 0,
    -- WebSocket客戶端
    WEB_SOCKET_CLIENT = 1,
    -- 剪贴板
    CLIPBOARD = 2
}

module.ModuleCallbackType = {
    MEMORY_MESSAGE_GENERATED = 0,
    PRINT=1
}

return module
