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
        <pre>${this.description}</pre>
      </div>
   `;
  }
}

function main() {
  const changelog = document.getElementById("changelog");
  let listItems = [];

  fetch("https://api.github.com/repos/tomascarruco/greenly/commits?per_page=15")
    .then((res) => res.json())
    .then((commits) => {
      commits.map((c) => listItems.push(c.commit));
    });

  if (listItems.length < 1) {
    
    const node = document.createElement("div");
    node.innerText= 'Try again, later.' ;

    changelog.appendChild(node);
    return;
  }

  for (let i = 0; i < listItems.length; i += 1) {
    const commit = listItems[i].commit.committer;
    const change = new Change(commit.date, commit.message, commit.author.name);
    console.log(`Commit: ${commit}`);

    const node = document.createElement("div");
    node.innerHTML = change.build();

    changelog.appendChild(node);
  }
}

(function () {
  // main();
})();
