//[サブスク削除]警告ホップアップJS
function cation() {
  //要素の取得
  const delete_btns = document.querySelectorAll(".delete_btn");
  const forms = document.querySelectorAll(".sub-delete-form");

  // 削除ボタン押下でイベント発火
  for(let i = 0; i < delete_btns.length;  i++){
    delete_btns[i].addEventListener('click',(e) => {
      e.preventDefault();
      const form = forms[i]
      const sub_delete_path = form.getAttribute("action");
      const formData = new FormData(form);
  
    // 削除警告画面
    Swal.fire({
      title: 'サブスクを削除します',
      html: '過去のレビューも削除され、元に戻せません。',
      footer: '<a href="#" class="text-blue-400 hover:bg-gray-200">サブスクの解約はこちら</a>',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      confirmButtonText: ' OK ',
      allowOutsideClick: false
    }).then((result) => {
      // OK押下の場合、削除処理
      if (result.isConfirmed) {
        const request  = new XMLHttpRequest();
        request.open("DELETE", sub_delete_path, true);
        request.responseType = "json";
        request.send(formData);
        request.onload = () => {
          //レスポンスが200以外の場合
          if (request.status != 200 || request.response.process_ng){
            Swal.fire({
              icon: 'error',
              title: '削除失敗',
              confirmButtonColor: '#cc3333',
              html: '大変お手数ですが、<a href="#" class="text-blue-400 hover:bg-gray-200">こちら</a>から<br>不具合のご報告をお願い申し上げます。'
            });
            return null;
          };
          //レスポンス200が返却されたら、削除完了ホップアップを表示
          Swal.fire({
            icon: 'success',
            title: '削除しました',
            text: `サブスク名：${request.response.subname}`,
            confirmButtonColor: '#3085d6',
            confirmButtonText: ' OK ',
            allowOutsideClick: false
          }).then((result) => {
            // OK押下後、マイページ画面のリロード
            if (result.isConfirmed) {
              location.href = location.href;
            };
          });
        };
      };
    });
  });
  };
};

window.addEventListener('load', cation);