function cation() {
  //要素の取得
  const sub_delete = document.getElementById("sub-delete");
  const form = document.getElementById("form");
  const formData = new FormData(form);

// 削除ボタン押下でイベント発火
  sub_delete.addEventListener('click',(e) => {
    e.preventDefault();
    const sub_delete_path = form.getAttribute("action");

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
        debugger
        request.responseType = "json";
        request.send(formData);
        request.onload = () => {
//レスポンスが200以外の場合
          if (request.status != 200){
            Swal.fire({
              icon: 'error',
              title: '削除失敗',
              html: '大変お手数ですが、<a href="#" class="text-blue-400 hover:bg-gray-200">こちら</a>から<br>不具合のご報告をお願い申し上げます。'
            });
            return null;
          };
//レスポンス200が返却されたら、削除完了ホップアップを表示
          console.log(request.response);
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
              location.reload();
            };
          });
        };  
      };
    });
  });
};

window.addEventListener('load', cation);