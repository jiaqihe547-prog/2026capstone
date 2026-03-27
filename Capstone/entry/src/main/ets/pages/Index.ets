import { DeviceInfo } from '../model/DeviceInfo';
import { SceneInfo } from '../model/SceneInfo';
import { AppState } from '../state/AppState';
import { DeviceManager } from '../business/DeviceManager';
import { SceneManager } from '../business/SceneManager';
import router from '@ohos.router';

@Entry
@Component
struct Index {
  // 【核心修改】页面维护自己的本地状态，不直接监听全局单例
  @State localDeviceList: DeviceInfo[] = [];
  @State localSceneList: SceneInfo[] = [];

  private appState: AppState = AppState.getInstance();
  private deviceManager: DeviceManager = new DeviceManager();
  private sceneManager: SceneManager = new SceneManager();

  // 页面第一次创建时初始化数据
  aboutToAppear(): void {
    this.appState.initMockData();
    this.refreshLocalData();
  }

  // 【核心修复】页面每次显示时，都从全局单例里重新拉取最新数据
  onPageShow(): void {
    this.refreshLocalData();
  }

  // 刷新本地数据的方法
  refreshLocalData(): void {
    // 深拷贝全局数据到本地，确保本地状态更新能触发UI刷新
    this.localDeviceList = JSON.parse(JSON.stringify(this.appState.deviceList));
    this.localSceneList = JSON.parse(JSON.stringify(this.appState.sceneList));
  }

  build() {
    Column() {
      // ---------------- 顶部标题区域 ----------------
      Text('Smart home control panel')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 20 });

      // ---------------- 快捷场景区域 ----------------
      Text('Quick Scene')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .width('100%')
        .margin({ left: 16, bottom: 12 });

      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceAround }) {
        ForEach(this.localSceneList, (scene: SceneInfo) => {
          this.SceneCard(scene)
        }, (scene: SceneInfo) => scene.id)
      }
      .width('100%')
      .margin({ bottom: 24 });

      // ---------------- 设备总览区域 ----------------
      Text('Device Overview')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .width('100%')
        .margin({ left: 16, bottom: 12 });

      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceAround }) {
        ForEach(this.localDeviceList, (device: DeviceInfo) => {
          this.DeviceCard(device)
        }, (device: DeviceInfo) => device.id)
      }
      .width('100%');

      // ---------------- 底部导航按钮 ----------------
      Row() {
        Button('Device List')
          .onClick(() => {
            router.pushUrl({ url: 'pages/DeviceList' });
          })
          .margin({ right: 16 });
        Button('Scene List')
          .onClick(() => {
            router.pushUrl({ url: 'pages/SceneList' });
          });
      }
      .margin({ top: 40 });
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5');
  }

  // ---------------- 自定义组件：场景卡片 ----------------
  @Builder
  SceneCard(scene: SceneInfo) {
    Column() {
      Text(scene.icon)
        .fontSize(32)
        .margin({ bottom: 8 });
      Text(scene.name)
        .fontSize(14);
    }
    .width('45%')
    .height(100)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .justifyContent(FlexAlign.Center)
    .margin({ bottom: 12 })
    .onClick(() => {
      // 先修改全局数据
      this.sceneManager.executeScene(scene.id);
      // 再刷新本地数据，触发UI更新
      this.refreshLocalData();
    })
  }

  // ---------------- 自定义组件：设备卡片 ----------------
  @Builder
  DeviceCard(device: DeviceInfo) {
    Column() {
      Text(device.type === 'light' ? '💡' : '🔌')
        .fontSize(32)
        .margin({ bottom: 8 });
      Text(device.name)
        .fontSize(14)
        .margin({ bottom: 4 });
      Text(device.isOn ? 'Open' : 'Close')
        .fontSize(12)
        .fontColor(device.isOn ? '#007DFF' : '#999999');
    }
    .width('45%')
    .height(120)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .justifyContent(FlexAlign.Center)
    .margin({ bottom: 12 })
    .onClick(() => {
      // 先修改全局数据
      this.deviceManager.toggleDevice(device.id);
      // 再刷新本地数据，触发UI更新
      this.refreshLocalData();
    })
  }
}