;; sBTC-Votary -  Governance Smart Contract
;; Allows community members to create, vote on, and execute proposals
(define-constant contract-owner tx-sender)
(define-constant err-not-owner (err u100))
(define-constant err-proposal-not-found (err u101))
(define-constant err-already-voted (err u102))
(define-constant err-voting-closed (err u103))
(define-constant err-insufficient-votes (err u104))
(define-constant err-not-proposal-creator (err u105))
(define-constant err-proposal-already-cancelled (err u106))
(define-constant err-invalid-voting-duration (err u107))
(define-constant err-cannot-modify-ended-proposal (err u108))
(define-constant err-invalid-proposal-id (err u109))

;; Data Maps

;; Proposal counter
(define-data-var next-proposal-id uint u0)

;; Proposal structure
(define-map proposals
  {proposal-id: uint}
  {
    creator: principal,
    description: (string-utf8 500),
    voting-start: uint,
    voting-end: uint,
    votes-for: uint,
    votes-against: uint,
    executed: bool,
    cancelled: bool
  }
)

;; Voter tracking
(define-map voter-votes
  {proposal-id: uint, voter: principal}
  {has-voted: bool}
)


;; Read only functions
;; Read proposal details
(define-read-only (get-proposal-details (proposal-id uint))
  (map-get? proposals {proposal-id: proposal-id})
)



;; Public Functions
;; Create a new proposal
(define-public (create-proposal (description (string-utf8 500)) (voting-duration uint))
  (let 
    (
      (proposal-id (var-get next-proposal-id))
      (current-block block-height)
      (description-length (len description))
    )
    (asserts! (> voting-duration u0) err-invalid-voting-duration)
    (asserts! (<= description-length u500) (err u110)) ;; New error code for invalid description length

    (map-set proposals 
      {proposal-id: proposal-id}
      {
        creator: tx-sender,
        description: description,
        voting-start: current-block,
        voting-end: (+ current-block voting-duration),
        votes-for: u0,
        votes-against: u0,
        executed: false,
        cancelled: false
      }
    )

    (var-set next-proposal-id (+ proposal-id u1))
    (ok proposal-id)
  )
)



;; Update voting duration
(define-public (update-voting-duration (proposal-id uint) (new-duration uint))
  (let 
    (
      (proposal (unwrap! (map-get? proposals {proposal-id: proposal-id}) err-proposal-not-found))
      (current-block block-height)
    )
    ;; Ensure proposal-id is valid
    (asserts! (< proposal-id (var-get next-proposal-id)) err-invalid-proposal-id)

    ;; Ensure only the proposal creator can update
    (asserts! (is-eq tx-sender (get creator proposal)) err-not-proposal-creator)

    ;; Ensure proposal is not yet closed
    (asserts! (< current-block (get voting-end proposal)) err-cannot-modify-ended-proposal)

    ;; Ensure new duration is valid (greater than 0)
    (asserts! (> new-duration u0) err-invalid-voting-duration)

    ;; Ensure proposal is not cancelled or executed
    (asserts! (not (get cancelled proposal)) err-proposal-already-cancelled)
    (asserts! (not (get executed proposal)) err-proposal-not-found)

    ;; Update voting end block
    (map-set proposals 
      {proposal-id: proposal-id}
      (merge proposal {voting-end: (+ current-block new-duration)})
    )

    (ok true)
  )
)

