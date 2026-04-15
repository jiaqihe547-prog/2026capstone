import { DeviceInfo } from '../model/DeviceInfo';
import { SceneInfo, SceneAction } from '../model/SceneInfo';
import { CommonConstants } from '../constant/CommonConstants';

// 全局响应式状态类（单例模式，整个项目共用这一个状态）
@Observed
export class AppState {
  // ---------------- 核心状态数据 ----------------
  // 智能设备列表
  deviceList: DeviceInfo[] = [];
  // 场景列表
  sceneList: SceneInfo[] = [];
  // 当前选中的设备（用于详情页）
  selectedDevice: DeviceInfo | null = null;
  // 分布式连接状态
  isDistributedConnected: boolean = false;

  // ---------------- 单例模式（全局唯一实例） ----------------
  private static instance: AppState;
  static getInstance(): AppState {
    if (!AppState.instance) {
      AppState.instance = new AppState();
    }
    return AppState.instance;
  }

  // ---------------- 初始化模拟数据（用于测试，不用连真实设备） ----------------
  initMockData(): void {
    // 1. 初始化模拟设备：补充更多房间与设备
    this.deviceList = [
      new DeviceInfo('d1', 'Living room light', CommonConstants.DEVICE_TYPE_LIGHT, 'Living room'),
      new DeviceInfo('d2', 'Bedroom lamp', CommonConstants.DEVICE_TYPE_LIGHT, 'Bedroom'),
      new DeviceInfo('d3', 'Living room socket', CommonConstants.DEVICE_TYPE_SOCKET, 'Living room'),
      new DeviceInfo('d4', 'Kitchen light', CommonConstants.DEVICE_TYPE_LIGHT, 'Kitchen'),
      new DeviceInfo('d5', 'Kitchen socket', CommonConstants.DEVICE_TYPE_SOCKET, 'Kitchen'),
      new DeviceInfo('d6', 'Bathroom light', CommonConstants.DEVICE_TYPE_LIGHT, 'Bathroom'),
      new DeviceInfo('d7', 'Study lamp', CommonConstants.DEVICE_TYPE_LIGHT, 'Study'),
      new DeviceInfo('d8', 'Study socket', CommonConstants.DEVICE_TYPE_SOCKET, 'Study'),
      new DeviceInfo('d9', 'Balcony light', CommonConstants.DEVICE_TYPE_LIGHT, 'Balcony')
    ];

    // 2. 初始化模拟场景：离家、回家、观影、烹饪、学习、睡眠
    this.sceneList = [
      // 离家模式：关闭所有设备
      new SceneInfo(
        CommonConstants.SCENE_ID_AWAY,
        'Leaving home model',
        '🏠',
        [
          new SceneAction('d1', false),
          new SceneAction('d2', false),
          new SceneAction('d3', false),
          new SceneAction('d4', false),
          new SceneAction('d5', false),
          new SceneAction('d6', false),
          new SceneAction('d7', false),
          new SceneAction('d8', false),
          new SceneAction('d9', false)
        ]
      ),
      // 回家模式：打开客厅主灯和插座
      new SceneInfo(
        CommonConstants.SCENE_ID_HOME,
        'Back home model',
        '🚪',
        [
          new SceneAction('d1', true, 80),
          new SceneAction('d3', true)
        ]
      ),
      // 观影模式：客厅灯调暗，客厅插座打开（电视/投影）
      new SceneInfo(
        'movie_mode',
        'Movie mode',
        '🎬',
        [
          new SceneAction('d1', true, 20),
          new SceneAction('d3', true),
          new SceneAction('d2', false),
          new SceneAction('d4', false),
          new SceneAction('d6', false)
        ]
      ),
      // 烹饪模式：打开厨房灯和厨房插座
      new SceneInfo(
        'cooking_mode',
        'Cooking mode',
        '🍳',
        [
          new SceneAction('d4', true, 90),
          new SceneAction('d5', true),
          new SceneAction('d1', false)
        ]
      ),
      // 学习模式：打开书房灯与书房插座
      new SceneInfo(
        'study_mode',
        'Study mode',
        '📚',
        [
          new SceneAction('d7', true, 85),
          new SceneAction('d8', true),
          new SceneAction('d2', false)
        ]
      ),
      // 睡眠模式：仅保留阳台灯微亮，其余常用灯关闭
      new SceneInfo(
        'sleep_mode',
        'Sleep mode',
        '🌙',
        [
          new SceneAction('d1', false),
          new SceneAction('d2', false),
          new SceneAction('d4', false),
          new SceneAction('d6', false),
          new SceneAction('d7', false),
          new SceneAction('d9', true, 10),
          new SceneAction('d3', false),
          new SceneAction('d5', false),
          new SceneAction('d8', false)
        ]
      )
    ];
  }
}