class Change {
  constructor(when, description, author) {
    this.when = when;
    this.description = description;
    this.author = author;
  }

  build() {
    return `
      <div data-wrapper>
        <h3 data-author>${this.author}</h3>
        <p class="my-1 bg-gray-200 h-px" />
        <p>${this.description}</p>
      </div>
   `;
  }
}

async function main() {
  const changelog = document.getElementById("changelog");
  let listItems = [];

  await fetch(
    "https://api.github.com/repos/tomascarruco/greenly/commits",
  )
    .catch((err) => console.error(err))
    .then((res) => res.json())
    .then((commits) => {
      console.log(commits[0].commit)
      commits.map((c) => listItems.push(c.commit));
    });

  if (listItems.length < 1) {
    const node = document.createElement("div");
    node.innerText = "Try again, later.";

    changelog.appendChild(node);
    return;
  }

  for (let i = 0; i < listItems.length; i += 1) {
    const commit = listItems[i].committer;
    const commit_message =listItems[i].message;

    const change = new Change(commit.date, commit_message, commit.name);

    const node = document.createElement("div");
    node.innerHTML = change.build();

    changelog.appendChild(node);
  }
}

(async function () {
  await main();
})();
