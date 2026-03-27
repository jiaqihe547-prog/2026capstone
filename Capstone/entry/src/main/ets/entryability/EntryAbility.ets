import UIAbility from '@ohos.app.ability.UIAbility';
import window from '@ohos.window';

export default class EntryAbility extends UIAbility {
  onDestroy() {
    super.onDestroy();
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    super.onWindowStageCreate(windowStage);
    // 加载首页
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        return;
      }
    });
  }

  onWindowStageDestroy() {
    super.onWindowStageDestroy();
  }

  onForeground() {
    super.onForeground();
  }

  onBackground() {
    super.onBackground();
  }
}