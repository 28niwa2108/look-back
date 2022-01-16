// [サブスク更新](マイページ)
window.addEventListener('load', () => {
  //要素の取得
  const today = new Date();
  today.setHours(23, 59, 59);
  const next_update_infos = document.querySelectorAll(".next_update_info");
  const sub_update_dates = document.querySelectorAll(".m-sub-update-date");
  const sub_update_links = document.querySelectorAll(".m-sub-update-link");
  const update_notifications = document.querySelectorAll(".update-notification");


  // 『更新日がきたら、次回更新日が更新リンクに変化する』
  for(let i = 0; i < sub_update_dates.length;  i++){
    const update_date = new Date(sub_update_dates[i].innerHTML);
    if (update_date <= today){
      next_update_infos[i].setAttribute ("class", "hidden");
      sub_update_links[i].removeAttribute("class", "hidden");
      update_notifications[i].removeAttribute("class", "hidden");
    };
  };

  // 『サブスク更新後、更新完了のホップアップを表示する』
  // 要素の取得
  const update_links = document.querySelectorAll(".m-sub-update-link_tag");
  const forms = document.querySelectorAll(".sub-update-form");

  // Clickして更新を押下でイベント発火
  for(let i = 0; i < update_links.length;  i++){
    update_links[i].addEventListener('click',(e) => {
      e.preventDefault();
      // リクエストを非同期で送信
      const form = forms[i]
      const sub_update_path = form.getAttribute("action");
      const formData = new FormData(form);
      const request  = new XMLHttpRequest();
      request.open("PATCH", sub_update_path, true);
      request.responseType = "json";
      request.send(formData);
      // レスポンス返却後
      request.onload = () => {
        my_page_path = document.getElementById("my-page").getAttribute("href");
        //レスポンスが200以外の場合
        if (request.status != 200 || request.response.process_ng){
          Swal.fire({
            icon: 'error',
            title: '更新失敗',
            confirmButtonColor: '#cc3333',
            html:`大変お手数ですが、<a href= "#" class="text-blue-400 hover:bg-gray-200">こちら</a>から<br>エラーのご報告をお願い申し上げます。(仮)<br>エラー：<span class="text-red-600">${request.response.error[0]}</span>`
          });
          return null;
        };
      //レスポンス200が返却されたら、更新完了ホップアップを表示
      Swal.fire({
        icon: 'success',
        title: '更新完了',
        html: `サブスク名：${request.response.data.sub_name}<br><br>続けて、振り返りをしましょう！`,
        footer: '<a href=`${my_page_path}` class="text-blue-400 hover:bg-gray-200">...あとで振り返る</a>',
        confirmButtonColor: '#3085d6',
        confirmButtonText: ' Go ',
        allowOutsideClick: false
      }).then((result) => {
        // OK押下後、振り返りページに遷移
        if (result.isConfirmed) {
          location.replace(request.response.data.look_back_path);
        };
      });
      };
    });
  };
});