let top_results = "";
let bottom_results = "";

let results_array = [...document.querySelector(top_results).innerText.split("\n"), ...document.querySelector(bottom_results).innerText.split("\n")].reverse();
let results = "";

for (let x = 0; x < results_array.length; x++) {
  let num = parseInt(results_array[x]); // String ko number mein convert karna safe rehta hai

  /* if (num === 0 || isNaN(num)) {
    continue; // Zero ko skip kar rahe hain jaisa aapne chaha tha
  } */
  if (num >= 1 && num <= 12) {
    results += "1"; // First Dozen
  } 
  else if (num >= 13 && num <= 24) {
    results += "2"; // Second Dozen
  } 
  else if (num >= 25 && num <= 36) {
    results += "3"; // Third Dozen
  }
}

console.log(results);
