<script>
  import RobotFactory from './Robots.svelte';
  let metamaskConnected = false;
  async function connectWallet() {
    if (window.ethereum) {
      window.web3 = new Web3(ethereum);
      await window.ethereum.enable();
      metamaskConnected = window.ethereum.isConnected();
    }
  }

  function onClickConncetWallet() {
    promise = connectWallet();
  }

  $: promise = connectWallet();
  $: metamaskConnceted = window.ethereum ? window.ethereum.isConnected() : false;
</script>

<main>
 {#if window.ethereum}
  <h2>Browser wallet is already connected to metamask: {metamaskConnected}</h2>
 {/if}
 {#if window.ethereum && !metamaskConnected}
  <button on:click={onClickConncetWallet}>Conncet Wallet</button>
  {:else}
<RobotFactory />
  {/if}
</main>

<style>
  .logo {
    height: 6em;
    padding: 1.5em;
    will-change: filter;
  }
  .logo:hover {
    filter: drop-shadow(0 0 2em #646cffaa);
  }
  .logo.svelte:hover {
    filter: drop-shadow(0 0 2em #ff3e00aa);
  }
  .read-the-docs {
    color: #888;
  }
</style>
