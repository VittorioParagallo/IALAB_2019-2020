;;;=================
;;;   PROGETTO CLIPS
;;;=================

(defmodule MAIN (export ?ALL))

;;****************
;;* DEFFUNCTIONS *
;;****************

(deffunction MAIN::ask-questions (?hint ?the-questions ?type-constraints)
   (printout t ?hint crlf)
   (bind ?answers (create$))
   (loop-for-count (?i 1 (length$ ?the-questions)) do
     (printout t (nth$ ?i ?the-questions))
     (bind ?answer (readline))
     (bind ?multiField (explode$ ?answer))
     (while (eq ?answer "")
       (printout t "Errore. Valore non inserito." crlf)
       (printout t (nth$ ?i ?the-questions))
       (bind ?answer (readline))
       (bind ?multiField (explode$ ?answer)))
     (loop-for-count (?j 1 (length$ ?multiField)) do
       (while (neq (type (nth$ ?j ?multiField)) (nth$ ?i ?type-constraints)) do
          (printout t "Errore. Valore errato." crlf)
          (printout t (nth$ ?i ?the-questions))
          (bind ?answer (readline))
          (bind ?multiField (explode$ ?answer))))
    (bind ?answers (insert$ ?answers ?i ?answer)))
  return ?answers)

;
(deffunction MAIN::get-variables-name-with-value (?variables ?value)
  (bind ?v (create$))
  (bind ?i 1)
  (while (< ?i (length$ ?variables)) do
    (if (eq (nth$ (+ ?i 1) ?variables) ?value) then (bind ?v (insert$ ?v 1 (nth$ ?i ?variables))))
    (bind ?i (+ ?i 2)))
  return ?v)

;funzione che calcola media
(deffunction MAIN::average (?values)
  (bind ?sum 0)
  (loop-for-count (?i 1 (length$ ?values)) do
    (bind ?sum (+ ?sum (nth$ ?i ?values))))
  (bind ?avg (/ ?sum (length$ ?values)))
  return ?avg)

;funzione che per ordinare i risultati per certezza e per prezzo
(deffunction MAIN::rating-sort (?f1 ?f2)
   (if (< (fact-slot-value ?f1 alt-certainty) (fact-slot-value ?f2 alt-certainty)) then (return TRUE)
   else (if (> (fact-slot-value ?f1 alt-certainty) (fact-slot-value ?f2 alt-certainty)) then (return FALSE)
        else (if (> (fact-slot-value ?f1 total-price) (fact-slot-value ?f2 total-price)) then (return TRUE)
             else (if (< (fact-slot-value ?f1 total-price) (fact-slot-value ?f2 total-price)) then (return FALSE)
                  else (return FALSE))))))

;;*****************
;;* INITIAL STATE *
;;*****************

(deftemplate MAIN::attribute
   (slot name)
   (multislot value)
   (slot certainty (default 100.0)))

(deftemplate MAIN::hotel-attribute
 (slot name)
 (slot certainty (type FLOAT) (default ?NONE))
 (multislot unknown-variables (type SYMBOL) (default ?NONE))
 (slot free-percent (type INTEGER) (range 0 100)))

(deftemplate MAIN::distance
  (slot loc1 (type SYMBOL) (default ?NONE))
  (slot loc2 (type SYMBOL) (default ?NONE))
  (slot dist (type INTEGER) (default ?NONE)))

(deftemplate MAIN::alternative
  (multislot hotels (type SYMBOL) (default ?NONE))
  (multislot times (type INTEGER) (default ?NONE))
  (slot total-price (type FLOAT) (default ?NONE))
  (multislot certainty (type FLOAT) (default ?DERIVE))
  (slot alt-certainty (type FLOAT) (default ?DERIVE))
  (slot zero-times (type INTEGER) (default ?NONE))
  (slot flag (default FALSE)))

(deftemplate MAIN::hotel
  (slot name (default ?NONE))
  (slot tr (type SYMBOL))
  (slot stars (type INTEGER) (range 1 4))
  (slot price-per-night (type FLOAT) (default ?DERIVE))
  (slot free-percent (type INTEGER) (default ?NONE) (range 0 100)))

;tipo di turismo
(deftemplate MAIN::tourism-resort
  (slot name (type SYMBOL))
  (slot region (type SYMBOL))
  (multislot type (type SYMBOL))
  (multislot score (type INTEGER) (range 0 5)))

;meta regole if then
(deftemplate MAIN::rule
  (slot certainty (default 100.0))
  (multislot if)
  (multislot then))

(defrule MAIN::start
  (declare (salience 10000))
  =>
  (set-fact-duplication TRUE)
  (bind ?facts (find-all-facts ((?f hotel-attribute)) TRUE))
  (loop-for-count (?i 1 (length$ ?facts)) do
  (retract (nth$ ?i ?facts)))
  (bind ?facts (find-all-facts ((?f alternative)) TRUE))
  (loop-for-count (?i 1 (length$ ?facts)) do
  (retract (nth$ ?i ?facts)))
  (bind ?facts (find-all-facts ((?f rule)) TRUE))
  (loop-for-count (?i 1 (length$ ?facts)) do
  (retract (nth$ ?i ?facts)))
  (refresh CHOOSE-HINTS::display-not-chosen-hints)
  (refresh HOTELS::generate-hotels)
  (refresh MAKE-RESULTS::remove-time-duplicate)
  (refresh MAKE-RESULTS::remove-people-duplicate)
  (refresh MAKE-RESULTS::remove-max-budget-duplicate)
  (refresh MAKE-RESULTS::make-possible-combinations)
  (refresh MAKE-RESULTS::make-feasible-solutions)
  (refresh MAKE-RESULTS::print-results)
  (focus CHOOSE-HINTS FORMAT-ATTRIBUTES REASONING-RULES RULES HOTELS MAKE-RESULTS))

(defrule MAIN::filter-hotels-for-unknown-values
  (declare (salience 100)
           (auto-focus TRUE))
  ?rem1 <- (hotel-attribute (name ?rel) (certainty ?per1) (unknown-variables $?uv1))
  ?rem2 <- (hotel-attribute (name ?rel) (certainty ?per2) (unknown-variables $?uv2))
  (test (neq ?rem1 ?rem2))
  (test (< (length$ ?uv1) (length$ ?uv2)))
  =>
  (retract ?rem2))

(defrule MAIN::filter-hotels-for-same-min-unknown-values
  (declare (salience 50)
           (auto-focus TRUE))
  ?rem1 <- (hotel-attribute (name ?rel) (certainty ?per1) (unknown-variables $?uv1))
  ?rem2 <- (hotel-attribute (name ?rel) (certainty ?per2) (unknown-variables $?uv2))
  (test (neq ?rem1 ?rem2))
  (test (and (neq (length$ ?uv1) 0) (eq ?uv1 ?uv2)))
  =>
  (retract ?rem2))

;; RULES COMBINE CERTAINTIES ;;
(defrule MAIN::combine-hotels-certainties-positive-signs
  (declare (salience 50)
           (auto-focus TRUE))
  ?rem1 <- (hotel-attribute (name ?rel) (certainty ?per1&:(>= ?per1 0)) (unknown-variables $?uv1))
  ?rem2 <- (hotel-attribute (name ?rel) (certainty ?per2&:(>= ?per2 0)) (unknown-variables $?uv2))
  (test (neq ?rem1 ?rem2))
  (test (or (and (eq (length$ ?uv1) 0) (eq (length$ ?uv2) 0)) (neq ?uv1 ?uv2)))
  =>
  (retract ?rem1)
  (modify ?rem2 (certainty (/ (- (* 100.0 (+ ?per1 ?per2)) (* ?per1 ?per2)) 100.0))))

(defrule MAIN::combine-hotels-certainties-negative-signs
  (declare (salience 50)
           (auto-focus TRUE))
  ?rem1 <- (hotel-attribute (name ?rel) (certainty ?per1&:(< ?per1 0)) (unknown-variables $?uv1))
  ?rem2 <- (hotel-attribute (name ?rel) (certainty ?per2&:(< ?per2 0)) (unknown-variables $?uv2))
  (test (neq ?rem1 ?rem2))
  (test (or (and (eq (length$ ?uv1) 0) (eq (length$ ?uv2) 0)) (neq ?uv1 ?uv2)))
  =>
  (retract ?rem1)
  (modify ?rem2 (certainty (+ (+ ?per1 ?per2) (/ (* ?per1 ?per2) 100.0)))))

(defrule MAIN::combine-hotels-certainties-opposite-signs
  (declare (salience 50)
           (auto-focus TRUE))
  ?rem1 <- (hotel-attribute (name ?rel) (certainty ?per1) (unknown-variables $?uv1))
  ?rem2 <- (hotel-attribute (name ?rel) (certainty ?per2) (unknown-variables $?uv2))
  (test (neq ?rem1 ?rem2))
  (test (or (and (eq (length$ ?uv1) 0) (eq (length$ ?uv2) 0)) (neq ?uv1 ?uv2)))
  (test (or (and (>= ?per1 0) (< ?per2 0)) (and (< ?per1 0) (>= ?per2 0))))
  =>
  (retract ?rem1)
  (bind ?mincf (min (abs ?per1) (abs ?per2)))
  (modify ?rem2 (certainty (/ (+ ?per1 ?per2) (- 1 ?mincf)))))

(defrule MAIN::combine-certainties-positive-signs
  (declare (salience 100)
           (auto-focus TRUE))
  ?rem1 <- (attribute (name ?rel&:(eq (sub-string 1 5 ?rel) "best-")) (value ?val) (certainty ?per1&:(>= ?per1 0)))
  ?rem2 <- (attribute (name ?rel&:(eq (sub-string 1 5 ?rel) "best-")) (value ?val) (certainty ?per2&:(>= ?per2 0)))
  (test (neq ?rem1 ?rem2))
  =>
  (retract ?rem1)
  (modify ?rem2 (certainty (/ (- (* 100.0 (+ ?per1 ?per2)) (* ?per1 ?per2)) 100.0))))

(defrule MAIN::combine-certainties-negative-signs
  (declare (salience 100)
           (auto-focus TRUE))
  ?rem1 <- (attribute (name ?rel&:(eq (sub-string 1 5 ?rel) "best-")) (value ?val) (certainty ?per1&:(< ?per1 0)))
  ?rem2 <- (attribute (name ?rel&:(eq (sub-string 1 5 ?rel) "best-")) (value ?val) (certainty ?per2&:(< ?per2 0)))
  (test (neq ?rem1 ?rem2))
  =>
  (retract ?rem1)
  (modify ?rem2 (certainty (+ (+ ?per1 ?per2) (/ (* ?per1 ?per2) 100.0)))))

(defrule MAIN::combine-certainties-opposite-signs
  (declare (salience 100)
           (auto-focus TRUE))
  ?rem1 <- (attribute (name ?rel&:(eq (sub-string 1 5 ?rel) "best-")) (value ?val) (certainty ?per1))
  ?rem2 <- (attribute (name ?rel&:(eq (sub-string 1 5 ?rel) "best-")) (value ?val) (certainty ?per2))
  (test (neq ?rem1 ?rem2))
  (test (or (and (>= ?per1 0) (< ?per2 0)) (and (< ?per1 0) (>= ?per2 0))))
  =>
  (retract ?rem1)
  (bind ?mincf (min (abs ?per1) (abs ?per2)))
  (modify ?rem2 (certainty (/ (+ ?per1 ?per2) (- 1 ?mincf)))))
;; RULES COMBINE CERTAINTIES END ;;

(defrule MAIN::filter-alternatives-about-zero-times-values
  (declare (auto-focus TRUE))
    ?a1 <- (alternative (zero-times ?zt1) (alt-certainty ?s1) (flag TRUE))
    ?a2 <- (alternative (zero-times ?zt2) (alt-certainty ?s2&:(<= ?s2 ?s1)) (flag TRUE))
  (test (neq ?a1 ?a2))
  (test (eq ?zt1 ?zt2))
  =>
  (retract ?a2))

(defrule MAIN::filter-alternatives-about-hotels-with-same-location
  (declare (auto-focus TRUE))
    ?a <- (alternative (hotels $?hotels-name) (times $?allocated-time) (flag TRUE))
  =>
  (bind ?flag TRUE)
  (loop-for-count (?cnt1 1 (length$ ?hotels-name)) do
    (do-for-fact ((?f hotel)) (eq ?f:name (nth$ ?cnt1 ?hotels-name)) (bind ?tr1 ?f:tr))
    (loop-for-count (?cnt2 (+ ?cnt1 1) (length$ ?hotels-name)) do
      (do-for-fact ((?f hotel)) (eq ?f:name (nth$ ?cnt2 ?hotels-name)) (bind ?tr2 ?f:tr))
      (if (and (eq ?tr1 ?tr2) (> (nth$ ?cnt1 ?allocated-time) 0) (> (nth$ ?cnt2 ?allocated-time) 0))
        then (bind ?flag FALSE))))
  (if (eq ?flag FALSE) then (retract ?a)))

;;***************************
;;* FORMAT-ATTRIBUTES RULES *
;;***************************

(defmodule FORMAT-ATTRIBUTES (import MAIN deftemplate attribute)
                             (import MAIN deftemplate tourism-resort))

(defrule FORMAT-ATTRIBUTES::format-visita-luoghi
  ?f <- (attribute (name visita-luoghi_)
        (value $?value)
        (certainty ?c))
  =>
  (bind ?cities (explode$ (nth$ 1 ?value)))
  (if (neq (nth$ 1 ?cities) /) then
    (loop-for-count (?i 1 (length$ ?cities)) do
      (bind ?city (nth$ ?i ?cities))
      (do-for-fact ((?f tourism-resort)) (eq ?f:name ?city) (bind ?region ?f:region))
      (assert (attribute (name city)
                         (value (str-cat ?region "-" ?city))
                         (certainty ?c)))
      (assert (attribute (name region)
                         (value ?region)
                         (certainty ?c)))))
    (assert (attribute (name time)
                       (value (integer (string-to-field (nth$ 2 ?value))))
                       (certainty ?c)))
    (assert (attribute (name max-budget)
                       (value (integer (string-to-field (nth$ 3 ?value))))
                       (certainty ?c)))
    (assert (attribute (name people)
                       (value (integer (string-to-field (nth$ 4 ?value))))
                       (certainty ?c)))
  (retract ?f))

(defrule FORMAT-ATTRIBUTES::format-region
  ?f <- (attribute (name only-region_)
        (value $?value)
        (certainty ?c))
  =>
  (assert (attribute (name only-region)
                     (value (sym-cat (nth$ 1 ?value)))
                     (certainty ?c)))
  (assert (attribute (name region)
                     (value (sym-cat (nth$ 1 ?value)))
                     (certainty ?c)))
  (retract ?f))

(defrule FORMAT-ATTRIBUTES::format-not-region
  ?f <- (attribute (name only-not-region_)
        (value $?value)
        (certainty ?c))
  =>
  (assert (attribute (name only-not-region)
                     (value (sym-cat (nth$ 1 ?value)))
                     (certainty ?c)))
  (assert (attribute (name not-region)
                     (value (sym-cat (nth$ 1 ?value)))
                     (certainty ?c)))
  (retract ?f))

(defrule FORMAT-ATTRIBUTES::format-max-stars
  ?f <- (attribute (name max-stars_)
        (value $?value)
        (certainty ?c))
  =>
  (assert (attribute (name max-stars)
                     (value (integer (string-to-field (sym-cat (nth$ 1 ?value)))))
                     (certainty 35)))
  (retract ?f))

(defrule FORMAT-ATTRIBUTES::format-min-stars
  ?f <- (attribute (name min-stars_)
        (value $?value)
        (certainty ?c))
  =>
  (assert (attribute (name min-stars)
                     (value (integer (string-to-field (sym-cat (nth$ 1 ?value)))))
                     (certainty 35)))
  (retract ?f))

(defrule FORMAT-ATTRIBUTES::format-tourism-type
  ?f <- (attribute (name tourism-type_)
        (value $?value)
        (certainty ?c))
  =>
  (bind ?types (explode$ (nth$ 1 ?value)))
  (loop-for-count (?i 1 (length$ ?types)) do
    (assert (attribute (name tourism-type)
                       (value (nth$ ?i ?types))
                       (certainty ?c))))
  (retract ?f))

;;**********************
;;* CHOOSE-HINTS RULES *
;;**********************

(defmodule CHOOSE-HINTS (import MAIN deftemplate attribute) (export deftemplate hint))

(deffacts CHOOSE-HINTS::display-hints
  (phase display-hints))

(deftemplate CHOOSE-HINTS::hint
   (slot number (type INTEGER) (default ?NONE))
   (slot attribute (default ?NONE))
   (slot the-hint (default ?NONE))
   (slot chosen (default FALSE))
   (slot already-asked (default FALSE))
   (multislot questions (type STRING) (default ?NONE))
   (multislot type-constraints (type SYMBOL) (default ?NONE))
   (multislot precursors (default ?DERIVE)))

(defrule CHOOSE-HINTS::display-not-chosen-hints
  ?dh <- (phase display-hints)
  =>
  (printout t "" crlf)
  (printout t "***SUGGERIMENTI***" crlf)
  (do-for-all-facts ((?f hint)) (eq ?f:chosen FALSE) (printout t ?f:the-hint crlf))
  (printout t "" crlf)
  (retract ?dh)
  (assert (phase choose-hint)))

(defrule CHOOSE-HINTS::choose-a-hint
  ?ch <- (phase choose-hint)
  =>
  (printout t "Scegli un suggerimento (0 per terminare): " crlf)
  (bind ?chosen-hint (read))
  (if (eq (type ?chosen-hint) INTEGER) then
    (bind ?available-hint (length$ (find-all-facts ((?f hint)) (= ?f:number ?chosen-hint)))))
  (while (or (neq (type ?chosen-hint) INTEGER) (and (neq ?chosen-hint 0) (= ?available-hint 0))) do
    (printout t "Errore. Scegli un suggerimento: " crlf)
    (bind ?chosen-hint (read))
    (if (eq (type ?chosen-hint) INTEGER) then
      (bind ?available-hint (length$ (find-all-facts ((?f hint)) (= ?f:number ?chosen-hint))))))
  (retract ?ch)
  (if (neq ?chosen-hint 0) then (assert (chosen-hint ?chosen-hint))
   else (assert (phase display-hints)) (pop-focus)))

(defrule CHOOSE-HINTS::enable-chosen-hint
  ?ch <- (chosen-hint ?h)
  ?f <- (hint (already-asked FALSE)
        (number ?h)
        (chosen FALSE))
  =>
  (retract ?ch)
  (modify ?f (chosen TRUE))
  (assert (phase display-hints))
  (focus HINTS))

;;***************
;;* HINTS RULES *
;;***************

(defmodule HINTS (import MAIN ?ALL) (import CHOOSE-HINTS deftemplate hint))

(defrule HINTS::ask-a-question
   ?f <- (hint (already-asked FALSE)
                   (precursors)
                   (chosen TRUE)
                   (the-hint ?the-hint)
                   (attribute ?the-attribute)
                   (questions $?the-questions)
                   (type-constraints $?type-constraints))
   =>
   (modify ?f (already-asked TRUE))
   (assert (attribute (name ?the-attribute)
                      (value (ask-questions ?the-hint ?the-questions ?type-constraints)))))

(defrule HINTS::precursor-is-satisfied
   ?f <- (hint (already-asked FALSE)
                   (precursors ?name is ?value $?rest))
         (attribute (name ?name) (value ?value))
   =>
   (if (eq (nth$ 1 ?rest) and)
    then (modify ?f (precursors (rest$ ?rest)))
    else (modify ?f (precursors ?rest))))

(defrule HINTS::precursor-is-not-satisfied
   ?f <- (hint (already-asked FALSE)
                   (precursors ?name is-not ?value $?rest))
         (attribute (name ?name) (value ~?value))
   =>
   (if (eq (nth$ 1 ?rest) and)
    then (modify ?f (precursors (rest$ ?rest)))
    else (modify ?f (precursors ?rest))))

;;********************
;;* CLIENTS REQUESTS *
;;********************

(defmodule CLIENTS-REQUESTS (import CHOOSE-HINTS deftemplate hint))

(deffacts CLIENTS-REQUESTS::hint-attributes
  (hint (attribute visita-luoghi_)
    (number 1)
    (the-hint "1. Visita luoghi nell'arco di un certo periodo di tempo spendendo al massimo una certa somma.")
    (questions "Quali luoghi intendi visitare (immettere / se non si desidera rispondere)? " "Per quanto tempo intendi visitarli (giorni)? "
      "Qual'e' il tuo budget massimo (euro)? " "Quante persone siete? " )
    (type-constraints SYMBOL INTEGER INTEGER INTEGER))
  (hint (attribute only-region_)
    (number 2)
    (the-hint "2. Visita solo luoghi appartenenti ad una specifica regione.")
    (questions "Inserire la regione: " )
    (type-constraints SYMBOL))
  (hint (attribute only-not-region_)
    (number 3)
    (the-hint "3. Visita solo luoghi non appartenenti ad una specifica regione.")
    (questions "Inserire la regione: " )
    (type-constraints SYMBOL))
  (hint (attribute max-stars_)
    (number 4)
    (the-hint "4. Prenota un albergo con al massimo con un determinato numero di stelle.")
    (questions "Inserire il massimo numero di stelle: " )
    (type-constraints INTEGER))
  (hint (attribute min-stars_)
    (number 5)
    (the-hint "5. Prenota un albergo con al minimo con un determinato numero di stelle.")
    (questions "Inserire il minimo numero di stelle: " )
    (type-constraints INTEGER))
  (hint (attribute tourism-type_)
    (number 6)
    (the-hint "6. Visita mete turistiche.")
    (questions "Inserire i tipi di turismo (separati da spazio): " )
    (type-constraints SYMBOL)))

;;*****************
;; The RULES module
;;*****************

(defmodule RULES (import MAIN deftemplate attribute) (export deftemplate rule)
                 (import MAIN deftemplate rule))

(defrule RULES::throw-away-ands-in-antecedent
  ?f <- (rule (if and $?rest))
  =>
  (modify ?f (if ?rest)))

(defrule RULES::throw-away-ands-in-consequent
  ?f <- (rule (then and $?rest))
  =>
  (modify ?f (then ?rest)))

(defrule RULES::remove-is-condition-when-satisfied
  ?f <- (rule (certainty ?c1)
              (if ?attribute is ?value $?rest))
  (attribute (name ?attribute)
             (value ?value)
             (certainty ?c2))
  =>
  (modify ?f (certainty (min ?c1 ?c2)) (if ?rest)))

(defrule RULES::remove-is-not-condition-when-satisfied
  ?f <- (rule (certainty ?c1)
              (if ?attribute is-not ?value $?rest))
  (attribute (name ?a&:(eq ?a (sym-cat "not-" ?attribute))) (value ?value) (certainty ?c2))
  =>
  (modify ?f (certainty (min ?c1 ?c2)) (if ?rest)))

(defrule RULES::perform-rule-consequent-is-with-certainty
  ?f <- (rule (certainty ?c1)
              (if)
              (then ?attribute is ?value with certainty ?c2 $?rest))
  =>
  (modify ?f (then ?rest))
  (assert (attribute (name ?attribute)
                     (value ?value)
                     (certainty (/ (* ?c1 ?c2) 100.0)))))

(defrule RULES::perform-rule-consequent-is-without-certainty
  ?f <- (rule (certainty ?c1)
              (if)
              (then ?attribute is ?value $?rest))
  (test (or (eq (length$ ?rest) 0)
            (neq (nth$ 1 ?rest) with)))
  =>
  (modify ?f (then ?rest))
  (assert (attribute (name ?attribute) (value ?value) (certainty ?c1))))

;;*******************
;;* REASONING RULES *
;;*******************

(defmodule REASONING-RULES (import RULES deftemplate rule)
                           (import MAIN deftemplate attribute))

;;genera regole per le città scelte dall'utente
(defrule REASONING-RULES::compile-citta'
  (attribute (name city)
             (value ?v))
  =>
  (assert (rule (if city is ?v)
      (then best-city is ?v with certainty 90))))

;;genera le regole per il tipo di turismo
(defrule REASONING-RULES::compile-rules-tourism-type
  (attribute (name tourism-type)
             (value ?v))
  =>
  (assert (rule (if tourism-type is ?v)
      (then best-tourism-type is ?v with certainty 80))))

;;genera le regole per le regioni scelte dall'utente
(defrule REASONING-RULES::compile-rules-region
  (attribute (name region)
             (value ?v))
  =>
  (assert (rule (if region is ?v)
      (then best-region is ?v with certainty 95))))

;;genera le regole per le regioni che l'utente non vuole
(defrule REASONING-RULES::compile-rules-not-region
  (attribute (name not-region)
             (value ?v))
  =>
  (assert (rule (if not-region is ?v)
      (then best-region is ?v with certainty -95))))

(defrule REASONING-RULES::compile-rules-only-region1
  (attribute (name only-region)
             (value ?v))
  (attribute (name city)
             (value ?city&:(and (neq ?city unknown) (eq (str-index ?v ?city) FALSE))))
  =>
  (bind ?j (str-index "-" ?city))
  (bind ?region (sym-cat (sub-string 1 (- ?j 1) ?city)))
  (assert (rule (if region is ?v)
      (then best-city is ?city with certainty -90 and
            best-region is ?region with certainty -20))))

(defrule REASONING-RULES::compile-rules-only-region2
  (attribute (name only-region)
             (value ?v))
  (attribute (name city)
             (value ?city&:(neq (str-index ?v ?city) FALSE)))
  =>
  (bind ?j (str-index "-" ?city))
  (bind ?region (sym-cat (sub-string 1 (- ?j 1) ?city)))
  (assert (rule (if region is ?v)
      (then best-city is ?city with certainty 90 and
            best-region is ?region with certainty 20))))

(defrule REASONING-RULES::compile-rules-only-region3
  (attribute (name only-region)
             (value ?v))
  (attribute (name region)
             (value ?v1&:(and (neq ?v1 ?v) (neq ?v1 unknown))))
  =>
  (assert (rule (if region is ?v)
      (then best-region is ?v1 with certainty -95))))

(defrule REASONING-RULES::compile-rules-only-not-region1
  (attribute (name only-not-region)
             (value ?v))
  (attribute (name city)
             (value ?city&:(and (neq ?city unknown) (eq (str-index ?v ?city) FALSE))))
  =>
  (bind ?j (str-index "-" ?city))
  (bind ?region (sym-cat (sub-string 1 (- ?j 1) ?city)))
  (assert (rule (if region is ?v)
      (then best-city is ?city with certainty 90 and
            best-region is ?region with certainty 20))))

(defrule REASONING-RULES::compile-rules-only-not-region2
  (attribute (name only-not-region)
             (value ?v))
  (attribute (name city)
             (value ?city&:(neq (str-index ?v ?city) FALSE)))
  =>
  (bind ?j (str-index "-" ?city))
  (bind ?region (sym-cat (sub-string 1 (- ?j 1) ?city)))
  (assert (rule (if region is ?v)
      (then best-city is ?city with certainty -90 and
            best-region is ?region with certainty -20))))

(defrule REASONING-RULES::compile-rules-only-not-region3
  (attribute (name only-not-region)
             (value ?v))
  (attribute (name region)
             (value ?v1&:(and (neq ?v1 ?v) (neq ?v1 unknown))))
  =>
  (assert (rule (if not-region is ?v)
      (then best-region is ?v1 with certainty 95))))

;;**************************
;;* HOTELS SELECTION RULES *
;;**************************

(defmodule HOTELS (import MAIN ?ALL) (export deftemplate hotel))

(deffacts HOTELS::unknown-attributes
  (attribute (name city) (value unknown) (certainty 0.0))
  (attribute (name max-budget) (value 500) (certainty 0.0))
  (attribute (name time) (value 1) (certainty 0.0))
  (attribute (name people) (value 1) (certainty 0.0))
  (attribute (name tourism-type) (value unknown) (certainty 0.0))
  (attribute (name region) (value unknown) (certainty 0.0))
  (attribute (name min-stars) (value 1) (certainty 0.0))
  (attribute (name max-stars) (value 4) (certainty 0.0)))

(deffacts HOTELS::the-tourism-type-list
   (tourism-type balneare)
   (tourism-type montano)
   (tourism-type lacustre)
   (tourism-type naturalistico)
   (tourism-type culturale)
   (tourism-type termale)
   (tourism-type religioso)
   (tourism-type sportivo)
   (tourism-type enogastronomico))

(deffacts HOTELS::the-tourism-resort-list
   (tourism-resort
    (name OlbiaTempio)
     (region Sardegna)
     (type balneare culturale)
     (score 2 1))
   (tourism-resort
     (name MedioCampidano)
     (region Sardegna)
     (type montano naturalistico)
     (score 2 3))
   (tourism-resort
     (name Cagliari)
     (region Sardegna)
     (type balenare culturale enogastronomico)
     (score 2 5))
   (tourism-resort
     (name Nuoro)
     (region Sardegna)
     (type sportivo enogastronomico)
     (score 1 1))
   (tourism-resort
     (name Salerno)
     (region Campania)
     (type naturalistico culturale religioso)
     (score 3 1 5))
   (tourism-resort
     (name Livorno)
     (region Toscana)
     (type balneare)
     (score 5))
   (tourism-resort
     (name Siena)
     (region Toscana)
     (type lacustre termale religioso)
     (score 2 1 1))
   (tourism-resort
     (name Savona)
     (region Liguria)
     (type naturalistico sportivo)
     (score 3 4 3)))

(deffacts HOTELS::the-hotels-list
  (hotel (name BeBDomusdeJanas)
         (tr OlbiaTempio)
         (stars 2)
         (price-per-night 75.0)
         (free-percent 46))
  (hotel (name HotelMareBlue)
         (tr OlbiaTempio)
         (stars 1)
         (price-per-night 50.0)
         (free-percent 0))
  (hotel (name ResidenceAviotel)
         (tr Livorno)
         (stars 2)
         (price-per-night 75.0)
         (free-percent 37))
  (hotel (name HotelVillaPadulella)
         (tr Livorno)
         (stars 4)
         (price-per-night 125.0)
         (free-percent 6))
  (hotel (name HotelleDune)
         (tr MedioCampidano)
         (stars 2)
         (price-per-night 75.0)
         (free-percent 51))
  (hotel (name HotelResidenceClubBaiadelleGinestre)
         (tr Cagliari)
         (stars 4)
         (price-per-night 125.0)
         (free-percent 75))
  (hotel (name NoraClubHotel)
         (tr Cagliari)
         (stars 4)
         (price-per-night 125.0)
         (free-percent 64))
  (hotel (name HotelSaMuvara)
         (tr Nuoro)
         (stars 3)
         (price-per-night 100.0)
         (free-percent 58))
  (hotel (name HotelSavoia)
         (tr Salerno)
         (stars 4)
         (price-per-night 125.0)
         (free-percent 91))
  (hotel (name HotelSantaCaterina)
         (tr Salerno)
         (stars 2)
         (price-per-night 75.0)
         (free-percent 63))
  (hotel (name HotelMargherita)
         (tr Salerno)
         (stars 1)
         (price-per-night 50.0)
         (free-percent 61))
  (hotel (name HotelPostaMarcucci)
         (tr Siena)
         (stars 1)
         (price-per-night 50.0)
         (free-percent 16))
  (hotel (name HotelPalazzuolo)
         (tr Siena)
         (stars 4)
         (price-per-night 125.0)
         (free-percent 61))
  (hotel (name AlbergoRistVillaAmbra)
         (tr Siena)
         (stars 1)
         (price-per-night 50.0)
         (free-percent 98))
  (hotel (name BeBIlCeppo)
         (tr Savona)
         (stars 2)
         (price-per-night 75.0)
         (free-percent 98)))

(deffacts HOTELS::distances
    (distance (loc1 Cagliari) (loc2 OlbiaTempio) (dist 239))
	(distance (loc1 Cagliari) (loc2 MedioCampidano) (dist 66))
	(distance (loc1 Cagliari) (loc2 Nuoro) (dist 94))
	(distance (loc1 Cagliari) (loc2 Siena) (dist 711))
	(distance (loc1 Cagliari) (loc2 Savona) (dist 707))
	(distance (loc1 Cagliari) (loc2 Livorno) (dist 489))
	(distance (loc1 Livorno) (loc2 OlbiaTempio) (dist 340))
	(distance (loc1 Livorno) (loc2 MedioCampidano) (dist 545))
	(distance (loc1 Livorno) (loc2 Nuoro) (dist 405))
	(distance (loc1 Livorno) (loc2 Siena) (dist 79))
	(distance (loc1 Livorno) (loc2 Savona) (dist 233))
	(distance (loc1 Livorno) (loc2 Salerno) (dist 487))
	(distance (loc1 MedioCampidano) (loc2 OlbiaTempio) (dist 97))
	(distance (loc1 MedioCampidano) (loc2 Nuoro) (dist 89))
	(distance (loc1 MedioCampidano) (loc2 Siena) (dist 670))
	(distance (loc1 MedioCampidano) (loc2 Savona) (dist 666))
	(distance (loc1 MedioCampidano) (loc2 Salerno) (dist 532))
	(distance (loc1 Nuoro) (loc2 OlbiaTempio) (dist 91))
	(distance (loc1 Nuoro) (loc2 Siena) (dist 531))
	(distance (loc1 Nuoro) (loc2 Savona) (dist 564))
	(distance (loc1 Nuoro) (loc2 Salerno) (dist 457))
	(distance (loc1 OlbiaTempio) (loc2 Siena) (dist 465))
	(distance (loc1 OlbiaTempio) (loc2 Savona) (dist 496))
	(distance (loc1 OlbiaTempio) (loc2 Salerno) (dist 459))
	(distance (loc1 Salerno) (loc2 Siena) (dist 472))
	(distance (loc1 Salerno) (loc2 Savona) (dist 796))
	(distance (loc1 Salerno) (loc2 Cagliari) (dist 511))
	(distance (loc1 Savona) (loc2 Siena) (dist 351)))

;;genera gli hotel attribute
(defrule HOTELS::generate-hotels
  (hotel (name ?name) (tr ?tr) (stars ?s) (price-per-night ?ppn) (free-percent ?fp))
  (tourism-resort (name ?tr) (region ?r) (type $? ?t $?))
  (tourism-type ?t)
  (attribute (name best-region) (value ?region) (certainty ?certainty-1))
  (attribute (name best-city) (value ?city) (certainty ?certainty-2))
  (attribute (name best-tourism-type) (value ?tt) (certainty ?certainty-3))
  (attribute (name min-stars) (value ?min-stars) (certainty ?certainty-4))
  (attribute (name max-stars) (value ?max-stars) (certainty ?certainty-5))
  (test (or (eq ?region ?r) (eq ?region unknown)))
  (test (or (eq ?city (sym-cat (str-cat ?r "-") ?tr)) (eq ?city unknown)))
  (test (or (eq ?tt ?t) (eq ?tt unknown)))
  =>
  (if (> ?min-stars ?s) then (bind ?certainty-4 -100.0))
  (if (< ?max-stars ?s) then (bind ?certainty-5 -100.0))
  (bind ?uv (get-variables-name-with-value (create$ region ?region city ?city tourism-type ?tt) unknown))
  (assert (hotel-attribute
             (name ?name)
             (certainty (average (create$ ?certainty-1 ?certainty-2 ?certainty-3 ?certainty-4 ?certainty-5)))
             (unknown-variables ?uv)
             (free-percent ?fp))))

;;**********************
;;* MAKE-RESULTS RULES *
;;**********************

(defmodule MAKE-RESULTS (import MAIN ?ALL) (import HOTELS deftemplate hotel))

(deftemplate MAKE-RESULTS::possible-combination
  (multislot hotels (type SYMBOL) (default ?NONE))
  (multislot times (type INTEGER) (default ?NONE))
  (multislot certainty (default ?DERIVE)))

(defrule MAKE-RESULTS::remove-time-duplicate
  (declare (salience 1000))
  ?rem <- (attribute (name time) (certainty ?per))
  (attribute (name time) (certainty ?per1&:(> ?per1 ?per)))
  =>
  (retract ?rem))

(defrule MAKE-RESULTS::remove-people-duplicate
  (declare (salience 1000))
  ?rem <- (attribute (name people) (certainty ?per))
  (attribute (name people) (certainty ?per1&:(> ?per1 ?per)))
  =>
  (retract ?rem))

(defrule MAKE-RESULTS::remove-max-budget-duplicate
  (declare (salience 1000))
  ?rem <- (attribute (name max-budget) (certainty ?per))
  (attribute (name max-budget) (certainty ?per1&:(> ?per1 ?per)))
  =>
  (retract ?rem))

(defrule MAKE-RESULTS::make-possible-combinations
  (attribute (name time) (value ?t) (certainty ?per))  ;;unifico con il numero di giorni
  =>
  (bind ?hotels (length$ (find-all-facts ((?f hotel-attribute)) (and (> ?f:free-percent 0) (> ?f:certainty 0.0)))))  ;;prendo gli hotel che hanno certezza > 0 e hanno disponibilità
  (bind ?h (integer ?hotels))
  (loop-for-count (?i 0 (integer (- (** (+ ?t 1) ?h) 1))) do    ;; (t+1)^h
    (bind ?allocated-time (create$))
    (bind ?n ?i)
    (loop-for-count (?j 1 ?h) do		;;da uno fino al numero di hotel
      (bind ?q (integer (/ ?n (+ ?t 1))))
      (bind ?r (integer (- ?n (* ?q (+ ?t 1)))))
      (bind ?n ?q)
      (bind ?allocated-time (insert$ ?allocated-time 1 ?r)))
    (bind ?sum 0)
    (bind ?j 1)
    (bind ?hotels-name (create$))
    (bind ?hotels-certainty (create$))
    (do-for-all-facts ((?f hotel-attribute)) (and (> ?f:free-percent 0) (> ?f:certainty 0.0))
      (bind ?hotels-name (insert$ ?hotels-name 1 ?f:name))
      (bind ?hotels-certainty (insert$ ?hotels-certainty 1 ?f:certainty))
      (bind ?sum (+ ?sum (nth$ ?j ?allocated-time)))
      (bind ?j (+ ?j 1)))
    (if (<= ?sum ?t) then
      (assert (possible-combination (hotels ?hotels-name) (times ?allocated-time) (certainty ?hotels-certainty))))))

(defrule MAKE-RESULTS::make-feasible-solutions
  ?pc <- (possible-combination (hotels $?hotels-name) (times $?allocated-time) (certainty $?hotels-certainty))
  (attribute (name max-budget) (value ?mb))
  (attribute (name people) (value ?p))
  =>
  (bind ?total-price 0.0)
  (loop-for-count (?c 1 (length$ ?hotels-name)) do
    (do-for-fact ((?f hotel)) (eq ?f:name (nth$ ?c ?hotels-name))
      (bind ?index (member$ ?f:name ?hotels-name)) (bind ?time (nth$ ?index ?allocated-time))
      (bind ?price (* (* ?f:price-per-night ?time) (integer (/ (+ ?p 1) 2))))
      (bind ?total-price (+ ?total-price ?price))))
  (retract ?pc)
  (if (>= ?mb ?total-price) then
    (bind ?zero-times (sym-cat ""))
    (loop-for-count (?i 1 (length$ ?allocated-time)) do (if (= (nth$ ?i ?allocated-time) 0) then (bind ?zero-times (sym-cat ?zero-times ?i))))
    (assert (alternative (hotels ?hotels-name) (times ?allocated-time) (total-price ?total-price) (certainty ?hotels-certainty) (zero-times ?zero-times)))))

(defrule MAKE-RESULTS::update-certainties-about-distances-and-free-percent
  ?a <- (alternative (hotels $?hotels) (times $?allocated-time) (total-price ?total-price) (certainty $?hotels-certainty) (flag FALSE))
  =>
  (bind ?sum 0)
  (bind ?h (create$))
  (bind ?path (create$))
  (loop-for-count (?i 1 (length$ ?hotels)) do (if (> (nth$ ?i ?allocated-time) 0) then ;; salva dentro h la lista degli hotel che hanno tempo allocato > 0
    (bind ?h (insert$ ?h 1 (nth$ ?i ?hotels)))))
  (loop-for-count (?i 1 (length$ ?hotels)) do
    (do-for-fact ((?f hotel)) (eq ?f:name (nth$ ?i ?hotels)) (if (> (nth$ ?i ?allocated-time) 0) then (bind ?sum (+ ?sum (/ ?f:free-percent 4))))) ;; mette in sum la disponibilità dell'hotel / 4
    (bind ?time-hotel1 (nth$ ?i ?allocated-time)) 					;; salvo il tempo del dell'hotel i
    (loop-for-count (?j (+ ?i 1) (length$ ?hotels)) do 				;; dall'hotel i in avanti
      (bind ?time-hotel2 (nth$ ?j ?allocated-time))					;; salvo tempo hotel j
      (if (and (> ?time-hotel1 0) (> ?time-hotel2 0)) then
        (do-for-fact ((?f hotel)) (eq ?f:name (nth$ ?i ?hotels)) (bind ?tr1 ?f:tr))				;; per ogni fatto hotel i estrae la città
        (do-for-fact ((?f hotel)) (eq ?f:name (nth$ ?j ?hotels)) (bind ?tr2 ?f:tr))				;; per ogni fatto hotel j estrae la città
        (do-for-fact ((?f distance))
          (or (and (eq ?f:loc1 ?tr1) (eq ?f:loc2 ?tr2))				;;unifica con le città1 e città2 dei fatti distanza
              (and (eq ?f:loc1 ?tr2) (eq ?f:loc2 ?tr1))
              (eq ?tr1 ?tr2))										;;stessa città
              (if (neq ?tr1 ?tr2) then (bind ?d ?f:dist) else (bind ?d 0)))	;; se le città sono diverse salvo la distanza altrimenti è 0
        (if (<= ?d 100.0) then																					;; se la distanza è minore di 100 metto l'hotel in path se non è presente
          (if (eq (member$ (nth$ ?i ?hotels) ?path) FALSE) then (bind ?path (insert$ ?path 1 (nth$ ?i ?hotels))))
          (if (eq (member$ (nth$ ?j ?hotels) ?path) FALSE) then (bind ?path (insert$ ?path 1 (nth$ ?j ?hotels)))))))
    (if (= ?time-hotel1 0) then											;; se l'hotel non ha tempo allocato allora la certezza viene abbassata
      (bind ?hotels-certainty (replace$ ?hotels-certainty ?i ?i -0.0001))))
  (loop-for-count (?i 1 (length$ ?path)) do								;;cancella dalla lista degli hotel gli hotel di path
    (bind ?index (member$ (nth$ ?i ?path) ?h))
    (if (neq ?index FALSE) then (bind ?h (delete$ ?h ?index ?index))))
  (if (> (+ (length$ ?h) (length$ ?path)) 1) then						;;lista hotel più quella di path maggiore di uno
    (loop-for-count (?i 1 (length$ ?h)) do
      (bind ?index (member$ (nth$ ?i ?h) ?hotels))
      (bind ?certainty-hotel (nth$ ?index ?hotels-certainty))
      (bind ?time-hotel (nth$ ?index ?allocated-time))
      (bind ?hotels-certainty (replace$ ?hotels-certainty ?index ?index -100.0))))	;;abbasso la certainty
  (if (= (+ (length$ ?h) (length$ ?path)) 1) then						;;lista hotel più quella di path = uno
    (bind ?index (member$ (nth$ 1 ?h) ?hotels))
    (bind ?certainty-hotel (nth$ ?index ?hotels-certainty))
    (bind ?time-hotel (nth$ ?index ?allocated-time))
    (bind ?hotels-certainty (replace$ ?hotels-certainty ?index ?index (* ?certainty-hotel ?time-hotel))))	;;moltiplico la certainty per il tempo hotel
  (loop-for-count (?i 1 (length$ ?path)) do					;;incrementa la certainty degli hoetel del path
    (bind ?index (member$ (nth$ ?i ?path) ?hotels))
    (bind ?certainty-hotel (nth$ ?index ?hotels-certainty))
    (bind ?time-hotel (nth$ ?index ?allocated-time))
    (bind ?hotels-certainty (replace$ ?hotels-certainty ?index ?index (* ?certainty-hotel ?time-hotel))))
  (loop-for-count (?i 1 (length$ ?hotels)) do
    (bind ?sum (+ ?sum (nth$ ?i ?hotels-certainty))))
  (modify ?a (certainty ?hotels-certainty) (alt-certainty ?sum) (flag TRUE)))	;;la certezza dell'alternativa è la somma delle certezze dell'hotel

(defrule MAKE-RESULTS::print-results (declare (salience -10))
  =>
   (bind ?hotels (create$))
   (bind ?trs (create$))
   (bind ?i 0)
   (do-for-all-facts ((?f hotel)) TRUE (bind ?hotels (insert$ ?hotels 1 ?f:name)) (bind ?trs (insert$ ?trs 1 ?f:tr)))
   (bind ?facts (find-all-facts ((?f alternative)) TRUE))
   (bind ?facts (sort rating-sort ?facts))
   (progn$ (?f ?facts)
     (if (< ?i 5) then
        (printout t "Alternativa #" (+ ?i 1) crlf)
        (bind ?h (fact-slot-value ?f hotels))
        (bind ?t (fact-slot-value ?f times))
        (printout t "Prezzo: " (fact-slot-value ?f total-price) crlf)
        (loop-for-count (?j 1 (length$ ?h)) do (bind ?index (member$ (nth$ ?j ?h) ?hotels)) (bind ?location (nth$ ?index ?trs))
          (if (> (nth$ ?j ?t) 0) then
            (printout t "Location: " ?location ", hotel: " (nth$ ?j ?h) ", giorni: "
            (nth$ ?j ?t) crlf)))
        (bind ?i (+ ?i 1))
     else (break)))
  (printout t crlf)
  (printout t "Desideri aggiungere qualche informazione? (si/no) ")
  (bind ?answer (read))
  (if (eq ?answer si) then (refresh MAIN::start)))
