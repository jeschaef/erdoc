import React from "react";

const DocsConfig = {
  project: {
    link: "https://github.com/jeschaef/erdoc",
  },
  docsRepositoryBase: "https://github.com/jeschaef/erdoc",
  logo: <span style={{ fontWeight: 800 }}>ERdoc Playground</span>,
  useNextSeoProps: () => ({
    titleTemplate: "%s",
  }),
  footer: {
    text: (
      <span>
        MIT {new Date().getFullYear()} ©{" "}
        <a href="https://github.com/matias-lg/er" target="_blank">
          ERdoc Playground
        </a>
        .
      </span>
    ),
  },
};

export default DocsConfig;
