// 全局常量定义文件
export class CommonConstants {
  // ---------------- 设备类型常量 ----------------
  static readonly DEVICE_TYPE_LIGHT: string = 'light'; // 灯光设备
  static readonly DEVICE_TYPE_SOCKET: string = 'socket'; // 插座设备

  // ---------------- 预设场景ID ----------------
  static readonly SCENE_ID_AWAY: string = 'away_mode'; // 离家模式
  static readonly SCENE_ID_HOME: string = 'home_mode'; // 回家模式

  // ---------------- 分布式数据存储Key ----------------
  static readonly KEY_DEVICE_LIST: string = 'device_list'; // 设备列表存储Key
  static readonly KEY_SCENE_LIST: string = 'scene_list'; // 场景列表存储Key

  // ---------------- UI布局常量 ----------------
  static readonly CARD_MARGIN: number = 12; // 卡片间距
  static readonly PAGE_PADDING: number = 16; // 页面边距
}