using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class horseBehaviour : MonoBehaviour
{

    NavMeshAgent nav;
    Vector3 navPos;
    [Header("Everything")]
    [HideInInspector] public Animator anim;
    public string horseName;
    public bool isTamed, beingRidden;
    public float moveWaitTimeMin, moveWaitTimeMax, moveDistanceMin, moveDistanceMax, moveSpeed, camSensitivityX;
    [HideInInspector] public Transform myRideAnchor;
    godScript GOD;
    characterController cC;
    Rigidbody rb;
    [Space(10)]
    [Header("Taming Stuff")]
    public throwablesScript.throwableTypes thingILike;
    public float tamingGoal;
    public float timerDecrease, happyTamingGoal, happyTimerDecrease;
    horseFunctionsScript hFS;
    public bool imHappy;
    ParticleSystem heartz;
    public AudioClip[] neighs;
    AudioSource aud;
    public AudioClip stepNoise;

    //horse riding movement stuff
    float vert, horiz;
    bool isMoving;
    Vector3 movement;

    //funny velocity stuff
    Vector3 oldPosition, newPosition;
    [HideInInspector] public float funnyVelocity;

    // Start is called before the first frame update
    void Start()
    {
        aud = GetComponent<AudioSource>();
        anim = GetComponent<Animator>();
        myRideAnchor = transform.Find("Model Parent/RideAnchor");
        GOD = GameObject.Find("GOD").GetComponent<godScript>();
        cC = GameObject.Find("Player").GetComponent<characterController>();
        nav = GetComponent<NavMeshAgent>();
        hFS = GetComponent<horseFunctionsScript>();
        rb = GetComponent<Rigidbody>();
        if(hFS == null)
        {
            hFS = new horseFunctionsScript();
        }
        changePosition();
        nav.speed = moveSpeed;
        GOD.horseCount++;
        heartz = transform.Find("Heartsies").gameObject.GetComponent<ParticleSystem>();
        neighTime();

    }

    // Update is called once per frame
    void Update()
    {
        aud.volume = GOD.audioVolume * 0.25f;

        if (beingRidden)
        {
            nav.enabled = false;
            if (isTamed)
            {
                horseRidingUpdate();
                anim.SetBool("isTamed", true);
            }
            else
            {
                horseTamingUpdate();
            }
        }
        else
        {
            if(isTamed == false)
            {
                nav.enabled = true;
            }
        }

        if (beingRidden == true)
        {
            transform.Translate(movement * moveSpeed * Time.deltaTime);
            if (cC.pauseMenu.activeSelf == false)
            {
                transform.Rotate(new Vector3(0, Input.GetAxis("Mouse X") * camSensitivityX, 0));
            }

        }

        //funny velocity stuff
        figureOutVelocity();
        if (funnyVelocity < 0)
        {
            funnyVelocity = funnyVelocity * -1;
        }
        anim.SetFloat("walkies", funnyVelocity / 3.5f);

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
            anim.SetTrigger("buck");
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

    //throwable interaction
    private void OnCollisionEnter(Collision other)
    {
        if(other.gameObject.tag == "throwable")
        {
            var otherTS = other.gameObject.GetComponent<throwablesScript>();
            if(otherTS.myType == thingILike)
            {
                if(GOD.tutorialTime == true)
                {
                    GOD.tBz.setFourthBool();
                }
                heartz.Play();
                imHappy = true;
                tamingGoal = happyTamingGoal;
                timerDecrease = happyTimerDecrease;
                Destroy(other.gameObject);
            }
        }
    }

    //keep an eye on this one it's shifty
    void figureOutVelocity()
    {
        newPosition = transform.position;
        funnyVelocity = (newPosition - oldPosition).magnitude / Time.deltaTime;
        oldPosition = transform.position;
    }

    void killMe()
    {
        Destroy(gameObject);
    }

    void neighTime()
    {
        aud.PlayOneShot(neighs[Random.Range(0, neighs.Length)]);
        Invoke("neighTime", Random.Range(10, 60));
    }

    public void playStepNoise()
    {
        aud.PlayOneShot(stepNoise);
    }
}
