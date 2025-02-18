import { bind } from "astal";
import Network from "gi://AstalNetwork";

const network = Network.get_default();

export default function NetworkStatus() {
  return (
    <box className={"network-status"}>
      {bind(network, "wifi").as((wifi) => {
        return (
          <button className={"wifi"}>
            <box>
              <icon icon={bind(wifi, "icon_name")} />

              <label label={bind(wifi, "ssid")} />
              <label label={bind(wifi, "strength").as((x) => x + "%")} />
              {/* {wifi} */}
            </box>
          </button>
        );
      })}
    </box>
  );
}
