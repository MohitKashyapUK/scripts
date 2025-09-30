let bottom_results = document.querySelector(".notranslate.desktop>#root>:first-child>:first-child>:nth-child(2)>:nth-child(2)>:first-child>:nth-last-child(2)>:last-child>:first-child>:first-child>:first-child>:last-child>:first-child>:first-child>:first-child>:first-child>:last-child")

bottom_results.innerText.split('\n').map(value => {
  if (value >= 1 && value <= 12) return 1
  else if (value >= 13 && value <= 24) return 2
  else if (value >= 25 && value <= 36) return 3
  else return 0
});
