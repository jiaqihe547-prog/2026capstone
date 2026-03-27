// 智能设备数据模型类
@Observed
export class DeviceInfo {
  // 设备唯一ID
  id: string;
  // 设备名称（如“客厅主灯”）
  name: string;
  // 设备类型（只能是常量里定义的 light 或 socket）
  type: string;
  // 设备所属房间（如“客厅”）
  room: string;
  // 设备开关状态
  isOn: boolean;
  // 灯光亮度（仅灯光设备有，插座设备为undefined）
  brightness?: number;

  // 构造函数：创建设备对象时必须传入的参数
  constructor(id: string, name: string, type: string, room: string) {
    this.id = id;
    this.name = name;
    this.type = type;
    this.room = room;
    // 默认初始状态：关闭
    this.isOn = false;
    // 如果是灯光设备，默认亮度50%
    this.brightness = type === 'light' ? 50 : undefined;
  }
}