;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname generate-cards) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/image)

(define START 15)
(define SIZE (* START 1.0))
(define OUTLINE (* SIZE 1.2))
(define FIELD (square (* START 1.8) "solid" "whitesmoke"))
(define CARD4 (overlay
               (square (* START 3.9) "solid" "whitesmoke")
               (square (* START 4) "solid" "black")))
(define CARD4CHECK (overlay
                    (square (* START 3.7) "solid" "whitesmoke")
                    (square (* START 4) "solid" "darkviolet")))
(define CARD3 (overlay
               (rectangle (* START 2) (* START 6) "outline" "black")
               (rectangle (* START 2) (* START 6) "solid" "whitesmoke")))

(define tone1 220)
(define tone2 120)
(define option-color-shade 
  (list (list (color 180 0 0)     
              (color 255 255 255) (color 255 tone1 tone1) (color 245 tone2 tone2) (color 200 0 0)) ;red
        (list (color 0 150 50 255) 
              (color 255 255 255) (color 200 255 200)     (color 100 240 100)     (color 0 180 0 255))  ;green
        (list (color 0 0 180)     
              (color 255 255 255) (color tone1 tone1 255) (color tone2 tone2 245) (color 0 0 180)) ;blue
        (list (color 0 150 150)   
              (color 255 255 255) (color tone1 255 255)   (color tone2 245 245)   (color 0 180 180)))) ;cyan
(define option-shape (list "square" "circle" "star" "triangle"))
(define option-number (build-list 4 identity))

;; String Color Color -> Image
;; produce one image of given type and colors (border, fill) on FIELD
(define (shape type border fill)
  (local [(define (combine fn fac)
            (overlay
             (fn (* SIZE fac) "solid" fill)
             (fn (* OUTLINE fac) "solid" border)
             FIELD))]
    (cond [(string=? type "square") (combine square 0.9)]
          [(string=? type "circle") (combine circle 0.5)]
          [(string=? type "triangle") (combine triangle 1.1)]
          [(string=? type "star") (combine star 0.85)])))

;; Natural String Color Color -> Image
;; generate one card4 with num number of shapes
(define (card4-main cons num type border fill)
  (local [(define item (shape type border fill))]
    (cond [(= num 1) 
           (overlay item cons)]
          [(= num 2)
           (overlay (beside item item) cons)]
          [(= num 3)
           (overlay (above item (beside item item)) cons)]
          [(= num 4)
           (overlay (above (beside item item) (beside item item)) cons)]
          [else  (square SIZE "solid" "purple")])))

(define (card4 num type border fill)
  (card4-main CARD4 num type border fill))

(define (card4-selected num type border fill)
  (card4-main CARD4CHECK num type border fill))

;; fn-for-card Natural String Color Color -> Image
;; generate cards per number, combine as one image
(define (gen-num card num type border fill)
  (if (= num 1)
      (card num type border fill)
      (beside 
       (card num type border fill)
       (gen-num card (sub1 num) type border fill))))

;; fn-for-card Natural Color Color -> Image
;; generate cards per shape, combine as one image
(define (gen-shape card num border fill)
  (local [(define (line shape)
            (gen-num card num shape border fill))]
    (beside
     (line (first option-shape))
     (if (>= num 2)
         (line (second option-shape))
         empty-image)
     (if (>= num 3)
         (line (third option-shape))
         empty-image)
     (if (>= num 4)
         (line (fourth option-shape))
         empty-image))))

;; fn-for-card Natural -> Image
;; generate all deck, on card by fn, and with num options
(define (gen-cards card num)
  (local [(define (line list-col)
            (local [(define (subline col)
                      (gen-shape card num (first list-col) col))]
              (above
               (subline (second list-col))
               (if (>= num 2)
                   (subline (third list-col))
                   empty-image)
               (if (>= num 3)
                   (subline (fourth list-col))
                   empty-image)
               (if (>= num 4)
                   (subline (fifth list-col))
                   empty-image))))]
    (above
     (line (first option-color-shade))
     (if (>= num 2)
         (line (second option-color-shade))
         empty-image)
     (if (>= num 3)
         (line (third option-color-shade))
         empty-image)
     (if (>= num 4)
         (line (fourth option-color-shade))
         empty-image))))

(gen-cards card4 2)
(gen-cards card4-selected 2)
(gen-cards card4 3)
(gen-cards card4-selected 3)
(gen-cards card4 4)
(gen-cards card4-selected 4)


;========

;; Natural String Color Color -> Image
;; generate one card3 with num number of shapes
#;
(define (card3 num type border fill)
  (local [(define item (shape type border fill))]
    (cond [(= num 1) 
           (overlay item CARD3)]
          [(= num 2)
           (overlay (above item item) CARD3)]
          [(= num 3)
           (overlay (above item item item) CARD3)]
          [else  (square SIZE "solid" "purple")])))


;(gen-num card3 3 "square" "red" "yellow")
;
;
;
;
;
;
;(define I1 (shape "square"   (color 255 0 0 255) (color 255 255 255 255)))
;(define I2 (shape "circle"   (color 255 0 0 255) (color 255 204 204 255)))
;(define I3 (shape "triangle" (color 0 255 0 255) (color 204 255 204 255)))
;(define I4 (shape "star"     (color 0 0 255 255) (color 204 204 255 255)))
;
;(define C41
;  (overlay I1            
;           CARD4))
;
;(define C42
;  (overlay (beside I2 I1)
;           CARD4))
;
;(define C43
;  (overlay (above I1
;                  (beside I3 I4))
;           CARD4))
;
;(define C44
;  (overlay (above
;            (beside I2 I1)
;            (beside I3 I4))
;           CARD4))
;
;(define C31
;  (overlay I1 CARD3))
;(define C32
;  (overlay (above I2 I3) CARD3))
;(define C33
;  (overlay(above I2 I4 I3) CARD3))
;
;(above
; (beside C41 C42)
; (beside C43 C44))
;
;(beside C31 C32 C33)

; =========
;
;
;;; Color -> Color
;;; gives lightened tone from color
;(define (light col shade)
;  (if (and (> (color-red col) (color-green col)) (> (color-red col) (color-blue col)))
;      (make-color
;       (color-red col)
;       (if (> (+ (color-green col) shade) 255)
;           255
;           (+ (color-green col) shade))
;       (if (> (+ (color-blue col) shade) 255)
;           255
;           (+ (color-blue col) shade)))
;       
;       (if (and (> (color-green col) (color-red col)) (> (color-green col) (color-blue col)))
;           (make-color
;            (if (> (+ (color-red col) shade) 255)
;                255
;                (+ (color-red col) shade))
;            (color-green col)
;            (if (> (+ (color-blue col) shade) 255)
;                255
;                (+ (color-blue col) shade)))
;           
;           (if (and (> (color-blue col) (color-red col)) (> (color-blue col) (color-green col)))
;               (make-color
;                (if (> (+ (color-red col) shade) 255)
;                    255
;                    (+ (color-red col) shade))
;                (if (> (+ (color-green col) shade) 255)
;                    255
;                    (+ (color-green col) shade))
;                (color-blue col))
;               col))))
;
; 
;(define (dark col shade)
;  (if (and (= color-green 0) (= color-blue 0))
;      (make-color
;       (if (< (+ (color-red col) shade) 0)
;           0
;           (+ (color-red col) shade))
;       0
;       0)
;      
;      (if (and (= color-red 0) (= color-blue 0))
;          (make-color
;           0
;           (if (< (+ (color-green col shade)) 0)
;               0
;               (+ (color-green col) shade))
;           0)
;          
;          (if (and (= color-red 0) (= color-green 0))
;              (make-color
;               0
;               0
;               (if (> (+ (color-blue col) shade) 0)
;                   0
;                   (+ (color-blue col) shade)))
;              col))))
;
;
;;; Color Number -> Color
;;; gives tone from color  
;(define (tone col shade)
;  (if (> shade 0)
;      (light col shade)
;      (dark col shade)))


;; fn-for-card Natural Color -> Image
;; gen row in one shade
;
;(define (gen-shade card num col)
;  (above
;   (gen-shape card num col (tone col 50))
;   (gen-shape card num col (tone col 100))
;   (gen-shape card num col (tone col 150))
;   (if (= num 4)
;       (gen-shape card num col (tone col 200))
;       empty-image)))