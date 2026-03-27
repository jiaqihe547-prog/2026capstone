import { DeviceInfo } from '../model/DeviceInfo';
import { AppState } from '../state/AppState';
import { DeviceManager } from '../business/DeviceManager';
import router from '@ohos.router';

@Entry
@Component
struct DeviceList {
  // 【核心修改】页面维护自己的本地状态
  @State localDeviceList: DeviceInfo[] = [];

  private appState: AppState = AppState.getInstance();
  private deviceManager: DeviceManager = new DeviceManager();

  // 页面每次显示时，都从全局单例里重新拉取最新数据
  aboutToAppear(): void {
    this.refreshLocalData();
  }

  onPageShow(): void {
    this.refreshLocalData();
  }

  // 刷新本地数据的方法
  refreshLocalData(): void {
    this.localDeviceList = JSON.parse(JSON.stringify(this.appState.deviceList));
  }

  build() {
    Column() {
      // ---------------- 顶部导航栏 ----------------
      Row() {
        Button('返回')
          .onClick(() => {
            router.back();
          });
        Text('设备列表')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center);
        Blank();
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White);

      // ---------------- 设备列表 ----------------
      List({ space: 12 }) {
        ForEach(this.localDeviceList, (device: DeviceInfo) => {
          ListItem() {
            this.DeviceItem(device)
          }
        }, (device: DeviceInfo) => device.id)
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: 16, right: 16, top: 12 })
      .backgroundColor('#F5F5F5');
    }
    .width('100%')
    .height('100%');
  }

  // ---------------- 自定义组件：设备列表项 ----------------
  @Builder
  DeviceItem(device: DeviceInfo) {
    Row() {
      Text(device.type === 'light' ? '💡' : '🔌')
        .fontSize(28)
        .margin({ right: 12 });
      Column() {
        Text(device.name)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .width('100%');
        Text(device.room)
          .fontSize(12)
          .fontColor('#999999')
          .width('100%')
          .margin({ top: 4 });
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start);
      Toggle({ type: ToggleType.Switch, isOn: device.isOn })
        .onChange((isOn: boolean) => {
          // 先修改全局数据
          this.deviceManager.toggleDevice(device.id);
          // 再刷新本地数据，触发UI更新
          this.refreshLocalData();
        });
    }
    .width('100%')
    .padding(16)
    .backgroundColor(Color.White)
    .borderRadius(12);
  }
}