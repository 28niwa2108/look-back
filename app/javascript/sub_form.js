//[サブスク登録・編集]更新日タイプカラム追加JS------------------------------------------
window.addEventListener('load', () => {
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
});

// ------------------------------------------------------------------------------

//[サブスク編集]編集確認ホップアップJS-------------------------------------------------
window.addEventListener('load', () => {
  //要素の取得
  const sub_edit_btn = document.getElementById("sub-edit-btn");
  const form = document.getElementById("sub-edit-form");
  const update_path = form.getAttribute("action");
  const mypage_path = document.getElementById("my-page").getAttribute("href");

  // 更新するボタン押下でイベント発火
  sub_edit_btn.addEventListener('click',(e) => {
    e.preventDefault();
    const formData = new FormData(form);

    // 更新確認画面
    Swal.fire({
      title: 'サブスク情報を更新します',
      html: '変更は次回更新日より、適応されます。<br>(サブスク名は即時反映されます。)',
      icon: 'info',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      confirmButtonText: ' OK ',
      allowOutsideClick: false
    }).then((result) => {
      // OK押下の場合、更新処理
      if (result.isConfirmed) {
        const request  = new XMLHttpRequest();
        request.open("POST", update_path, true);
        request.responseType = "json";
        request.send(formData);
        request.onload = () => {
          //レスポンスが200以外の場合
          if (request.status != 200){
            Swal.fire({
              icon: 'error',
              title: '更新失敗',
              confirmButtonColor: '#cc3333',
              html: '大変お手数ですが、<a href="https://forms.gle/FwRDjMCqmdw4XaPW7" class="text-blue-400 hover:bg-gray-200">こちら</a>から<br>不具合のご報告をお願い申し上げます。'
            });
            return null;
          };
          if (request.response.process_ng) {
            Swal.fire({
              icon: 'error',
              title: '更新失敗',
              confirmButtonColor: '#cc3333',
              confirmButtonText: ' OK ',
              html: `${request.response.error_messages[0]}`
            });
            return null;
          };
          //レスポンス200が返却されたら、更新完了ホップアップを表示
          Swal.fire({
            icon: 'success',
            title: '更新しました',
            confirmButtonColor: '#3085d6',
            confirmButtonText: ' OK ',
            allowOutsideClick: false
          }).then((result) => {
            // OK押下後、マイページ画面へ遷移
            if (result.isConfirmed) {
              location.replace(mypage_path);
            };
          });
        };
      };
    });
  });
});
