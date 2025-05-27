document.addEventListener("turbo:load", () => {
  const SearchButton = document.getElementById("SearchButton");
  const SearchPopup = document.getElementById("O_SearchPopup");
  const ClosePopup = document.getElementById("A_CloseButton");

  // Отображаем попап
  SearchButton.addEventListener("click", () => {
    SearchPopup.style.display = "flex";
    document.getElementById("A_SearchInput").focus();
  });

  // Закрытие по крестику
  ClosePopup.addEventListener("click", () => {
    SearchPopup.style.display = "none";
  });

  // Закрытие при расфокусировке
  SearchPopup.addEventListener("click", (e) => {
    if (e.target === SearchPopup) {
      SearchPopup.style.display = "none";
    }
  });
});
  