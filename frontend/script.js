function toggleMenu() {
  const menu = document.querySelector(".menu-links");
  const icon = document.querySelector(".hamburger-icon");
  menu.classList.toggle("open");
  icon.classList.toggle("open");
}

const URL = "https://api.jovan.cloud/visits";

const visits = document.getElementsByClassName("visits")[0]

async function sentData() {

  try {
    const response = await fetch(URL, { method: "POST" })

    if (!response.ok) {
      throw new Error(`Response status: ${response.status}`);
    }

  } catch (error) {
    console.error(error.message);
  }
}

sentData()

async function getData() {

  try {
    const response = await fetch(URL);
    
    if (!response.ok) {
      throw new Error(`Response status: ${response.status}`);
    }
    
    const data = await response.json();

    visits.innerHTML = `${data} visits`

  } catch (error) {
    console.error(error.message);
    visits.innerHTML = `This page has been visited, at least, 476 times`
  }
}

getData()