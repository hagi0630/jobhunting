        var form = document.forms[0];
        function CheckPassword() {
            // エラーメッセージをクリアする
            form.pwd2.setCustomValidity("");
            // パスワードの一致確認
            if (form.pwd1.value != form.pwd2.value) {
                // 一致していなかったら、エラーメッセージを表示する
                form.pwd2.setCustomValidity("パスワードと確認用パスワードが一致しません");
            }
        };
        // 入力値チェックエラーが発生したときの処理
        form.addEventListener("invalid", function() {
            document.getElementById("errorMessage").innerHTML = "入力値にエラーがあります";
        }, false);
