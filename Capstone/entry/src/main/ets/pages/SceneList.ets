import { SceneInfo } from '../model/SceneInfo';
import { AppState } from '../state/AppState';
import { SceneManager } from '../business/SceneManager';
import router from '@ohos.router';

@Entry
@Component
struct SceneList {
  // 获取全局响应式状态
  @State appState: AppState = AppState.getInstance();
  // 初始化场景管理类
  private sceneManager: SceneManager = new SceneManager();

  build() {
    Column() {
      // ---------------- 顶部导航栏 ----------------
      Row() {
        Button('Back')
          .onClick(() => {
            // 点击返回首页
            router.back();
          });
        Text('Scene List')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center);
        // 占位用，让标题居中
        Blank();
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White);

      // ---------------- 场景列表 ----------------
      List({ space: 12 }) {
        ForEach(this.appState.sceneList, (scene: SceneInfo) => {
          ListItem() {
            this.SceneItem(scene)
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: 16, right: 16, top: 12 })
      .backgroundColor('#F5F5F5');
    }
    .width('100%')
    .height('100%');
  }

  // ---------------- 自定义组件：场景列表项 ----------------
  @Builder
  SceneItem(scene: SceneInfo) {
    Row() {
      // 场景图标
      Text(scene.icon)
        .fontSize(28)
        .margin({ right: 12 });
      // 场景名称
      Text(scene.name)
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .layoutWeight(1);
      // 执行按钮
      Button('Execute')
        .onClick(() => {
          // 点击执行场景
          this.sceneManager.executeScene(scene.id);
        });
    }
    .width('100%')
    .padding(16)
    .backgroundColor(Color.White)
    .borderRadius(12);
  }
}