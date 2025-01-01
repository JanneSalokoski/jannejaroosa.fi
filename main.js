function set_radio_classes(participate, yes_button, no_button) {
    if (participate == true) {
        yes_button.classList.add("checked")
        no_button.classList.remove("checked")
    }
    else {
        no_button.classList.add("checked")
        yes_button.classList.remove("checked")
    }
}

function clear_form(name_field, diet_field, yes_button, no_button) {
    name_field.value = "";
    diet_field.value = "";

    set_radio_classes(true, yes_button, no_button);
}

function send_response(response) {
    fetch("http://127.0.0.1:8001/responses/", {
        method: "POST",
        body: JSON.stringify(response),
        headers: {
            "Content-type": "application/json; charset=UTF-8"
        }
    })
        .then( (res) => res.json() )
        .then( (json) => console.log(json) );
}

function init() {
    let state = {
        name: "",
        diet: "",
        rsvp: true
    };

    let name_field = document.querySelector(".form input#name");
    name_field.onchange = (event) => {
        state.name = event.target.value;
    };

    let diet_field = document.querySelector(".form textarea#diet");
    diet_field.onchange = (event) => {
        state.diet = event.target.value;
    }

    let yes_button = document.querySelector(".form .radio input#yes");
    yes_button.onclick = (event) => {
        set_radio_classes(true, yes_button, no_button)
        state.rsvp = true;
    }

    let no_button = document.querySelector(".form .radio input#no");
    no_button.onclick = (event) => {
        set_radio_classes(false, yes_button, no_button)
        state.rsvp = false;
    }

    let form = document.querySelector(".form");
    let confirmation = document.querySelector(".confirmation");

    let submit_button = document.querySelector(".form input#save");
    submit_button.onclick = (event) => {
        if (state.name !== "") {
            send_response(state);
            clear_form(name_field, diet_field, yes_button, no_button);

            state.name = "";
            state.diet = "";
            state.rsvp = true;

            confirmation.classList.remove("hidden")
            form.classList.add("hidden")
        }
        else {
            console.log("No name!");
        }
    }

    let another_button = document.querySelector(".confirmation input#another")
    another_button.onclick = (event) => {
        confirmation.classList.add("hidden")
        form.classList.remove("hidden")
    }
}

init()
