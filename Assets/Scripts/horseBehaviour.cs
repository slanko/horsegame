using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class horseBehaviour : MonoBehaviour
{
    Animator anim;
    NavMeshAgent nav;
    Vector3 navPos;
    public bool isTamed, beingRidden;
    public float moveWaitTimeMin, moveWaitTimeMax, moveDistanceMin, moveDistanceMax, moveSpeed, camSensitivityX;
    public string horseName;
    public Transform myRideAnchor;
    godScript GOD;
    characterController cC;
    [Header("Taming Stuff")]
    public throwablesScript.throwableTypes thingILike;
    public float tamingGoal;
    public float timerDecrease, happyTamingGoal, happyTimerDecrease;
    horseFunctionsScript hFS;

    //horse riding movement stuff
    float vert, horiz;
    bool isMoving;
    Vector3 movement;

    // Start is called before the first frame update
    void Start()
    {
        anim = GetComponent<Animator>();
        myRideAnchor = transform.Find("Model Parent/RideAnchor");
        GOD = GameObject.Find("GOD").GetComponent<godScript>();
        cC = GameObject.Find("Player").GetComponent<characterController>();
        nav = GetComponent<NavMeshAgent>();
        hFS = GetComponent<horseFunctionsScript>();
        if(hFS == null)
        {
            hFS = new horseFunctionsScript();
        }
        changePosition();
    }

    // Update is called once per frame
    void Update()
    {
        if (beingRidden)
        {
            nav.enabled = false;
            if (isTamed)
            {
                horseRidingUpdate();
            }
            else
            {
                horseTamingUpdate();
            }
        }
        else
        {
            nav.enabled = true;
        }

        //probably could do this cleaner with the functions but i'm just getting it working
        if (cC.currentState == characterController.playerState.TAMING)
        {
            anim.SetBool("goingCrazy", true);
        }
        else
        {
            anim.SetBool("goingCrazy", false);
        }
    }

    void horseRidingUpdate()
    {
        vert = Input.GetAxisRaw("Vertical");
        horiz = Input.GetAxisRaw("Horizontal");
        movement = new Vector3(horiz, 0, vert);
        isMoving = movement.magnitude > 0;
    }

    void horseTamingUpdate()
    {
        if(GOD.tamingSlider.value <= GOD.tamingSlider.minValue)
        {
            cC.goToRagdoll();
            changePosition();
        }
    }

    void changePosition()
    {
        if(beingRidden == false)
        {
            Invoke("changePosition", Random.Range(moveWaitTimeMin, moveWaitTimeMax));
            navPos = Random.insideUnitSphere * Random.Range(moveDistanceMin, moveDistanceMax) + transform.position;
            nav.SetDestination(navPos);
        }
    }

    private void FixedUpdate()
    {
        if(beingRidden == true)
        {
            transform.Translate(movement * moveSpeed * Time.deltaTime);
            transform.Rotate(new Vector3(0, Input.GetAxis("Mouse X") * camSensitivityX, 0));
        }
    }

    //throwable interaction
    private void OnCollisionEnter(Collision other)
    {
        if(other.gameObject.tag == "throwable")
        {
            var otherTS = other.gameObject.GetComponent<throwablesScript>();
            if(otherTS.myType == thingILike)
            {
                tamingGoal = happyTamingGoal;
                timerDecrease = happyTimerDecrease;
                Destroy(other.gameObject);
            }
        }
    }
}
