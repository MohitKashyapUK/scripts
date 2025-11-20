let bottom_results_selector = "";
let bottom_results = document.querySelector(bottom_results_selector).innerText;

console.log(bottom_results.replace(/\n/g, ' '));

let results_string = bottom_results.split('\n').map(value => {
  if (value >= 1 && value <= 12) return 1
  else if (value >= 13 && value <= 24) return 2
  else if (value >= 25 && value <= 36) return 3
  else return 0
}).reverse().toString().replaceAll(",", "");

console.log(results_string);
