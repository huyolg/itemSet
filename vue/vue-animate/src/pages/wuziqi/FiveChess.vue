<template>
  <div class="chess-container">
    <!-- <div> -->
    <canvas id="five-chess-canvas" width="450" height="450" @click="handlerClickCanvas">
      Your browser does not support the Canvas API. Please upgrade your browser.
    </canvas>
    <!-- </div> -->
    <div class="bottom">
      <el-button>重新开始</el-button>
    </div>
  </div>
</template>

<script setup>
import { onMounted } from 'vue'
var canvas_el, ctx
var has = []
var me = true
var allwins = []
var count = 0
var mythiswin = []
var pcthiswin = []
var over = false
// 绘制棋盘
const drawChessBoard = () => {
  canvas_el = document.getElementById('five-chess-canvas')
  ctx = canvas_el.getContext('2d')

  ctx.beginPath()
  for (var i = 0; i < 15; i++) {
    ctx.moveTo(15, 15 + 30 * i)
    ctx.lineTo(435, 15 + 30 * i)

    ctx.moveTo(15 + 30 * i, 15)
    ctx.lineTo(15 + 30 * i, 435)
  }

  ctx.strokeStyle = '#666'
  ctx.stroke()
  ctx.closePath()

  ctx.beginPath()
  ctx.moveTo(215, 225)
  ctx.lineTo(235, 225)
  ctx.moveTo(225, 215)
  ctx.lineTo(225, 235)
  ctx.lineWidth = 2
  ctx.strokeStyle = '#000'
  ctx.stroke()
  ctx.closePath()
}

const hasChess = () => {
  for (let i = 0; i < 15; i++) {
    has[i] = []
    for (let j = 0; j < 15; j++) {
      has[i][j] = 0
    }
  }
}

const countWins = () => {
  for (let i = 0; i < 15; i++) {
    allwins[i] = []
    for (let j = 0; j < 15; j++) {
      allwins[i][j] = []
    }
  }
  // 横向
  for (let i = 0; i < 15; i++) {
    for (let j = 0; j < 11; j++) {
      for (let k = 0; k < 5; k++) {
        allwins[i][j + k][count] = true
      }
      count++
    }
  }
  // 竖向
  for (let i = 0; i < 15; i++) {
    for (let j = 0; j < 11; j++) {
      for (let k = 0; k < 5; k++) {
        allwins[j + k][i][count] = true
      }
      count++
    }
  }
  // 斜
  for (let i = 0; i < 11; i++) {
    for (let j = 0; j < 11; j++) {
      for (let k = 0; k < 5; k++) {
        allwins[i + k][j + k][count] = true
      }
      count++
    }
  }
  // 反斜
  for (let i = 14; i > 3; i--) {
    for (let j = 0; j < 11; j++) {
      for (let k = 0; k < 5; k++) {
        allwins[i - k][j + k][count] = true
      }
      count++
    }
  }

  for (let k = 0; k <= count; k++) {
    mythiswin[k] = 0
    pcthiswin[k] = 0
  }
}

const oneStep = (i, j, me) => {
  ctx.beginPath()
  ctx.arc(30 * i + 15, 30 * j + 15, 13, 0, Math.PI * 2)
  let gradient = ctx.createRadialGradient(30 * i + 15, 30 * j + 15, 13, 30 * i + 15, 30 * j + 15, 0)
  if (me) {
    gradient.addColorStop(0, '#0a0a0a')
    gradient.addColorStop(1, '#636766')
  } else {
    gradient.addColorStop(0, '#b1b1b1')
    gradient.addColorStop(1, '#f9f9f9')
  }
  ctx.fillStyle = gradient
  ctx.fill()
  ctx.closePath()
}

const handlerClickCanvas = (e) => {
  if (over) {
    return
  }
  if (!me) {
    return
  }
  let x = e.offsetX
  let y = e.offsetY
  let i = Math.floor(x / 30)
  let j = Math.floor(y / 30)
  if (has[i][j] == 0) {
    oneStep(i, j, true)
    has[i][j] = 1
    console.log(`落子坐标：x = ${i}; y = ${j}`)

    for (let k = 0; k <= count; k++) {
      if (allwins[i][j][k]) {
        mythiswin[k]++
        pcthiswin[k] = 50
        if (mythiswin[k] == 5) {
          alert('you win')
          over = true
        }
      }
    }
    if (!over) {
      me = !me
      AI()
    }
  }
}

const AI = () => {
  var myScore = []
  var pcScore = []
  var max = 0
  var u = 0
  var v = 0
  for (let i = 0; i < 15; i++) {
    myScore[i] = []
    pcScore[i] = []
    for (let j = 0; j < 15; j++) {
      myScore[i][j] = 0
      pcScore[i][j] = 0
    }
  }

  for (let i = 0; i < 15; i++) {
    for (let j = 0; j < 15; j++) {
      if (has[i][j] == 0) {
        for (let k = 0; k <= count; k++) {
          if (mythiswin[k] == 1) {
            myScore[i][j] += 200
          } else if (mythiswin[k] == 2) {
            myScore[i][j] += 400
          } else if (mythiswin[k] == 3) {
            myScore[i][j] += 1000
          } else if (mythiswin[k] == 4) {
            myScore[i][j] += 10000
          }

          if (pcthiswin[k] == 1) {
            pcScore[i][j] += 220
          } else if (pcthiswin[k] == 2) {
            pcScore[i][j] += 420
          } else if (pcthiswin[k] == 3) {
            pcScore[i][j] += 1100
          } else if (pcthiswin[k] == 4) {
            pcScore[i][j] += 20000
          }
        }
        console.log('max = ', max)
        if (myScore[i][j] > max) {
          max = myScore[i][j]
          u = i
          v = j
        } else if (myScore[i][j] == max) {
          if (pcScore[i][j] > pcScore[u][v]) {
            u = i
            v = j
          }
        }

        if (pcScore[i][j] > max) {
          max = pcScore[i][j]
          u = i
          v = j
        } else if (pcScore[i][j] == max) {
          if (myScore[i][j] > myScore[u][v]) {
            u = i
            v = j
          }
        }
      }
    }
  }
  oneStep(u, v, false)
  has[u][v] = 2
  console.log(`机器落子坐标： x = ${u};y = ${v}`)
  for (let k = 0; k <= count; k++) {
    if (allwins[u][v][k]) {
      pcthiswin[k]++
      mythiswin[k] = 60
      if (pcthiswin[k] == 5) {
        alert('很遗憾，电脑赢！')
        over = true
      }
    }
  }

  if (!over) {
    me = !me
  }
}
onMounted(() => {
  drawChessBoard()
  hasChess()
  countWins()
})
</script>

<style scoped>
.chess-container {
  width: 100vw;
  height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
}
.bottom {
  margin-top: 20px;
}
</style>
