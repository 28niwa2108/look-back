//[サブスク登録・編集]更新日タイプカラム追加JS
function judge_type() {

  //要素の取得
  const update_type_ids = document.querySelectorAll("#update_type_id");
  const day_type_btn = document.getElementById("day_type_btn")

  //render時も、下記focusイベントが発火するように対応
  update_type_ids[0].click();

  //更新タイプに「月 または 年」を選択中は、更新日カラムを追加表示
  for(let i = 0; i < update_type_ids.length;  i++){
    update_type_ids[i].addEventListener('focus',(e) => {
      if ( i != 0 ){
        day_type_btn.removeAttribute("class", "hidden")
        day_type_btn.setAttribute("class", "relative p-2 w-10/12 mx-auto")
      };
    });
  };

  //更新タイプに「日」を選択中は、更新日カラムを非表示
  for(let i = 0; i < update_type_ids.length;  i++){
    update_type_ids[i].addEventListener('focus',(e) => {
      if ( i == 0 ){
        day_type_btn.setAttribute("class", "hidden")
      };
    });
  };
};

window.addEventListener('load', judge_type);