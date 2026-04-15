import { DeviceInfo } from '../model/DeviceInfo';
import { SceneInfo } from '../model/SceneInfo';
import { AppState } from '../state/AppState';
import { DeviceManager } from '../business/DeviceManager';
import { SceneManager } from '../business/SceneManager';
import { agentLog } from '../util/AgentDebugLog';
import router from '@ohos.router';

@Entry
@Component
struct Index {
  // 【核心修改】页面维护自己的本地状态，不直接监听全局单例
  @State localDeviceList: DeviceInfo[] = [];
  @State localSceneList: SceneInfo[] = [];
  @State selectedRoom: string | null = null;

  private appState: AppState = AppState.getInstance();
  private deviceManager: DeviceManager = new DeviceManager();
  private sceneManager: SceneManager = new SceneManager();

  // 页面第一次创建时初始化数据
  aboutToAppear(): void {
    // #region agent log
    agentLog('Index.ets:aboutToAppear', 'enter', {
      'deviceLen': this.appState.deviceList.length,
      'sceneLen': this.appState.sceneList.length,
      'd1On': this.appState.deviceList[0] ? (this.appState.deviceList[0].isOn ? 1 : 0) : -1
    }, 'H4');
    // #endregion
    // 仅在首次进入且全局状态为空时初始化，避免返回首页后状态被重置
    if (this.appState.deviceList.length === 0 || this.appState.sceneList.length === 0) {
      this.appState.initMockData();
      // #region agent log
      agentLog('Index.ets:aboutToAppear', 'after initMockData', {
        'deviceLen': this.appState.deviceList.length,
        'd1On': this.appState.deviceList[0] ? (this.appState.deviceList[0].isOn ? 1 : 0) : -1
      }, 'H4');
      // #endregion
    }
    this.refreshLocalData();
  }

  // 【核心修复】页面每次显示时，都从全局单例里重新拉取最新数据
  onPageShow(): void {
    // #region agent log
    agentLog('Index.ets:onPageShow', 'fired', {
      'd1On': this.appState.deviceList[0] ? (this.appState.deviceList[0].isOn ? 1 : 0) : -1
    }, 'H1');
    // #endregion
    this.refreshLocalData();
  }

  // 刷新本地数据的方法
  refreshLocalData(): void {
    // 深拷贝全局数据到本地，确保本地状态更新能触发UI刷新
    const d1Before = this.appState.deviceList[0] ? (this.appState.deviceList[0].isOn ? 1 : 0) : -1;
    this.localDeviceList = JSON.parse(JSON.stringify(this.appState.deviceList));
    this.localSceneList = JSON.parse(JSON.stringify(this.appState.sceneList));
    const local0 = this.localDeviceList[0];
    const d1After = local0 ? (local0.isOn ? 1 : 0) : -1;
    // #region agent log
    agentLog('Index.ets:refreshLocalData', 'after clone', {
      'globalD1On': d1Before,
      'localD1On': d1After,
      'localLen': this.localDeviceList.length
    }, 'H2');
    // #endregion
  }

  build() {
    Column() {
      Scroll() {
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
          Row() {
            if (this.selectedRoom !== null) {
              Button('Back')
                .onClick(() => {
                  this.selectedRoom = null;
                })
                .margin({ left: 16, right: 8 });
              Text(this.selectedRoom)
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .layoutWeight(1)
                .textAlign(TextAlign.Start);
            } else {
              Text('Device Overview')
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .layoutWeight(1)
                .textAlign(TextAlign.Start)
                .margin({ left: 16 });
            }
          }
          .width('100%')
          .margin({ bottom: 12 });

          if (this.selectedRoom === null) {
            Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceAround }) {
              ForEach(this.getRoomList(), (room: string) => {
                this.RoomCard(room)
              }, (room: string) => room)
            }
            .width('100%');
          } else {
            Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceAround }) {
              ForEach(this.localDeviceList.filter(d => d.room === this.selectedRoom), (device: DeviceInfo) => {
                this.DeviceCard(device)
              }, (device: DeviceInfo) => device.id)
            }
            .width('100%');
          }

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
          .margin({ top: 40, bottom: 24 });
        }
        .width('100%')
      }
      .scrollBar(BarState.Auto)
      .scrollable(ScrollDirection.Vertical)
      .edgeEffect(EdgeEffect.Spring)
      .width('100%')
      .layoutWeight(1);
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

  private getRoomList(): string[] {
    const seen: Record<string, boolean> = {};
    const rooms: string[] = [];
    this.localDeviceList.forEach((d: DeviceInfo) => {
      const room = d.room ?? '';
      if (room && !seen[room]) {
        seen[room] = true;
        rooms.push(room);
      }
    });
    return rooms;
  }

  // ---------------- 自定义组件：房间卡片 ----------------
  @Builder
  RoomCard(room: string) {
    Column() {
      Text('🏠')
        .fontSize(30)
        .margin({ bottom: 8 });
      Text(room)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: 4 });
      Text(`${this.localDeviceList.filter(d => d.room === room).length} devices`)
        .fontSize(12)
        .fontColor('#999999');
    }
    .width('45%')
    .height(110)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .justifyContent(FlexAlign.Center)
    .margin({ bottom: 12 })
    .onClick(() => {
      this.selectedRoom = room;
    })
  }
}