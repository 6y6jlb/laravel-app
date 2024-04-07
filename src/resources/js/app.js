import "./bootstrap";
import { createApp } from "vue";
import AppComponent from "./components/App.vue";

const app = createApp({});

app.component("app-component", AppComponent).mount("#app");
