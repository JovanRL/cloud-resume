function toggleMenu() {
  const menu = document.querySelector(".menu-links");
  const icon = document.querySelector(".hamburger-icon");
  menu.classList.toggle("open");
  icon.classList.toggle("open");
}


const visits = document.getElementsByClassName("visits")[0]

async function getData() {
  const url = "https://api.jovan.cloud/visits";

  try {
    const response = await fetch(url);
    
    if (!response.ok) {
      throw new Error(`Response status: ${response.status}`);
    }
    
    const data = await response.json();

    visits.innerHTML = `This page has been visited ${data} times`

  } catch (error) {
    console.error(error.message);
    visits.innerHTML = `This page has been visited, at least, 5 times`
  }
}

getData()