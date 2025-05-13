| Type                 | Description                                                  |
| -------------------- | ------------------------------------------------------------ |
| **Feat**             | 새로운 기능 추가                                             |
| **Fix**              | 버그 수정                                                    |
| **Docs**             | 문서 수정                                                    |
| **Style**            | 코드 formatting, 세미콜론 누락, 코드 자체의 변경이 없는 경우 |
| **Refactor**         | 코드 리팩토링                                                |
| **Test**             | 테스트 코드, 리팩토링 테스트 코드 추가                       |
| **Chore**            | 패키지 매니저 수정, 그 외 기타 수정 (예: .gitignore)         |
| **Design**           | CSS 등 사용자 UI 디자인 변경                                 |
| **Comment**          | 필요한 주석 추가 및 변경                                     |
| **Rename**           | 파일 또는 폴더 명을 수정하거나 옮기는 작업만인 경우          |
| **Remove**           | 파일을 삭제하는 작업만 수행한 경우                           |
| **!BREAKING CHANGE** | 커다란 API 변경의 경우                                       |
| **!HOTFIX**          | 급하게 치명적인 버그를 고쳐야 하는 경우                      |

### `.gitmessage.txt` 적용 법 (클론된 레포에만 적용)

```shell
$ git config commit.template .gitmessage.txt
```

이후 터미널에서 `git commit`하고 엔터 누르면 메시지가 뜹니다. 혹시 nano 에디터가 뜬다면 다음 명령어를 입력해주세요. 글로벌로 적용됩니다.

```shell
$ git config --global core.editor "code --wait" # vscode 사용 시 (강추)
$ git config --global core.editor "vim" # vim 사용 시
```
