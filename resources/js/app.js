import "./bootstrap";
import { createApp } from "vue";
import AppComponent from "./components/App.vue";
import SimpleComponent from "./components/SimpleComponent.vue";
import VueWizard from "vue3-wizard";
import "vue3-wizard/dist/style.css";

const app = createApp({});

app.component("app-component", AppComponent)
    .use(VueWizard)
    .component("vue-simple-componet", SimpleComponent)
    .mount("#app");
