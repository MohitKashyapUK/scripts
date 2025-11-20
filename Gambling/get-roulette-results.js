let bottom_results_selector = "";
let bottom_results = document.querySelector(bottom_results_selector).innerText;

/* let results_string = bottom_results.split('\n').map(value => {
  if (value >= 1 && value <= 12) return 1
  else if (value >= 13 && value <= 24) return 2
  else if (value >= 25 && value <= 36) return 3
  else return 0
}).reverse().toString().replaceAll(",", ""); */

let results_string = "";
for (let x=0, arr=bottom_results.split('\n').reverse(); x < arr.length; x++) {
  const value = arr[x];
  if (value >= 1 && value <= 12) results_string += "1";
  else if (value >= 13 && value <= 24) results_string += "2";
  else if (value >= 25 && value <= 36) results_string += "3";
  else results_string += "0";
}

console.log(results_string);
