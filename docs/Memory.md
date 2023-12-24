# Memory

这个模块提供了一些直接操作以撒内存数据的接口，利用此模块可以自定义实现本项目未提供的接口  
内存操作只能对数据区进行，对代码区进行内存操作会导致游戏崩溃  
内存操作十分危险，如果你不知道自己在做什么，请不要使用这个模块

- [Memory](#memory)
  - [模块函数](#模块函数)
    - [ReadInt32()](#readint32)
    - [WriteInt32()](#writeint32)
    - [ReadInt64()](#readint64)
    - [WriteInt64()](#writeint64)
    - [ReadInt16()](#readint16)
    - [WriteInt16()](#writeint16)
    - [ReadInt8()](#readint8)
    - [WriteInt8()](#writeint8)
    - [ReadUInt32()](#readuint32)
    - [WriteUInt32()](#writeuint32)
    - [ReadUInt64()](#readuint64)
    - [WriteUInt64()](#writeuint64)
    - [ReadUInt16()](#readuint16)
    - [WriteUInt16()](#writeuint16)
    - [ReadUInt8()](#readuint8)
    - [WriteUInt8()](#writeuint8)
    - [ReadDouble()](#readdouble)
    - [WriteDouble()](#writedouble)
    - [ReadFloat()](#readfloat)
    - [WriteFloat()](#writefloat)
    - [ReadMemory()](#readmemory)
    - [WriteMemory()](#writememory)
    - [GetImageBase()](#getimagebase)
    - [CalcAddress()](#calcaddress)

## 模块函数

### ReadInt32()

integer ReadInt32(integer address)

- 功能：读取指定地址的32位带符号整数值

- 参数：
  - `address`：地址

- 返回值：指定地址的32位带符号整数值

---

### WriteInt32()

WriteInt32(integer address, integer value)

- 功能：将32位带符号整数值写入指定地址

- 参数：
  - `address`：地址
  - `value`：要写入的32位带符号整数值

---

### ReadInt64()

integer ReadInt64(integer address)

- 功能：读取指定地址的64位带符号整数值

- 参数：
  - `address`：地址

- 返回值：指定地址的64位带符号整数值

---

### WriteInt64()

WriteInt64(integer address, integer value)

- 功能：将64位带符号整数值写入指定地址

- 参数：
  - `address`：地址
  - `value`：要写入的64位带符号整数值

---

### ReadInt16()

integer ReadInt16(integer address)

- 功能：读取指定地址的16位带符号整数值

- 参数：
  - `address`：地址

- 返回值：指定地址的16位带符号整数值

---

### WriteInt16()

WriteInt16(integer address, integer value)

- 功能：将16位带符号整数值写入指定地址

- 参数：
  - `address`：地址
  - `value`：要写入的16位带符号整数值

---

### ReadInt8()

integer ReadInt8(integer address)

- 功能：读取指定地址的8位带符号整数值

- 参数：
  - `address`：地址

- 返回值：指定地址的8位带符号整数值

---

### WriteInt8()

WriteInt8(integer address, integer value)

- 功能：将8位带符号整数值写入指定地址

- 参数：
  - `address`：地址
  - `value`：要写入的8位带符号整数值

---

### ReadUInt32()

integer ReadUInt32(integer address)

- 功能：读取指定地址的32位无符号整数值

- 参数：
  - `address`：地址

- 返回值：指定地址的32位无符号整数值

---

### WriteUInt32()

WriteUInt32(integer address, integer value)

- 功能：将32位无符号整数值写入指定地址

- 参数：
  - `address`：地址
  - `value`：要写入的32位无符号整数值

---

### ReadUInt64()

integer ReadUInt64(integer address)

- 功能：读取指定地址的64位无符号整数值

- 参数：
  - `address`：地址

- 返回值：指定地址的64位无符号整数值

---

### WriteUInt64()

WriteUInt64(integer address, integer value)

- 功能：将64位无符号整数值写入指定地址

- 参数：
  - `address`：地址
  - `value`：要写入的64位无符号整数值

---

### ReadUInt16()

integer ReadUInt16(integer address)

- 功能：读取指定地址的16位无符号整数值

- 参数：
  - `address`：地址

- 返回值：指定地址的16位无符号整数值

---

### WriteUInt16()

WriteUInt16(integer address, integer value)

- 功能：将16位无符号整数值写入指定地址

- 参数：
  - `address`：地址
  - `value`：要写入的16位无符号整数值

---

### ReadUInt8()

integer ReadUInt8(integer address)

- 功能：读取指定地址的8位无符号整数值

- 参数：
  - `address`：地址

- 返回值：指定地址的8位无符号整数值

---

### WriteUInt8()

WriteUInt8(integer address, integer value)

- 功能：将8位无符号整数值写入指定地址

- 参数：
  - `address`：地址
  - `value`：要写入的8位无符号整数值

---

### ReadDouble()

number ReadDouble(integer address)

- 功能：读取指定地址的64位双精度浮点数

- 参数：
  - `address`：地址

- 返回值：指定地址的64位双精度浮点数

---

### WriteDouble()

WriteDouble(integer address, number value)

- 功能：将64位双精度浮点数写入指定地址

- 参数：
  - `address`：地址
  - `value`：要写入的64位双精度浮点数

---

### ReadFloat()

number ReadFloat(integer address)

- 功能：读取指定地址的32位单精度浮点数

- 参数：
  - `address`：地址

- 返回值：指定地址的32位单精度浮点数

---

### WriteFloat()

WriteFloat(integer address, number value)

- 功能：将32位单精度浮点数写入指定地址

- 参数：
  - `address`：地址
  - `value`：要写入的32位单精度浮点数

---

### ReadMemory()

string ReadMemory(integer address, integer size)

- 功能：读取指定地址的指定长度的二进制数据

- 参数：
  - `address`：地址
  - `size`：要读取的二进制数据长度

- 返回值：指定地址的指定长度的二进制数据

---

### WriteMemory()

WriteMemory(integer address, string value)

- 功能：将二进制数据写入指定地址

- 参数：
  - `address`：地址
  - `value`：要写入的二进制数据

---

### GetImageBase()

integer GetImageBase()

- 功能：获取以撒进程的主模块基地址
- 返回值：以撒进程的主模块基地址

---

### CalcAddress()

integer CalcAddress(integer address ,integer offset...)

- 功能：通过基址和多级偏移计算最终地址
- 参数：
  - `address`：基址
  - `offset`：偏移，可以传入多个，代表多级偏移
- 返回值：最终计算结果的地址
- 使用示例（获取角色的主动道具ID并输出，然后将主动道具修改为硫磺火）：

    ````lua
    if IsaacSocket then
        local imageBase = IsaacSocket.Memory.GetImageBase()
        local gameOffset = 0x7FD65C
        local playersOffset = 0x1BA50
        local playerOffset = 0x0
        local activesOffset = 0x14C4
        local itemOffset = 0x0
        local address = IsaacSocket.Memory.CalcAddress(imageBase + gameOffset, playersOffset, playerOffset,
            activesOffset + itemOffset)
        local item = IsaacSocket.Memory.ReadUInt32(address)
        print("item: " .. item)
        IsaacSocket.Memory.WriteUInt32(address, 118)
    end
    ````
