let selector = "#root > div > div > div.content--6d02a > div:nth-child(2) > div > div.top-container--67c84.autoFullScreenEnabled--57102 > div.top-right--83089";

let results_array = document.querySelector(selector).innerText.split("\n").reverse();
let results = "";

for (let x = 0; x < results_array.length; x++) {
  let num = parseInt(results_array[x]); // String ko number mein convert karna safe rehta hai

  if (num === 0 || isNaN(num)) {
    results += "0"; // continue; // Zero ko skip kar rahe hain jaisa aapne chaha tha
  }
  else if (num >= 1 && num <= 12) {
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
