using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class horseBehaviour : MonoBehaviour
{
    NavMeshAgent nav;
    Vector3 navPos;
    public bool isTamed, beingRidden;
    public float moveWaitTimeMin, moveWaitTimeMax, moveDistanceMin, moveDistanceMax, moveSpeed, camSensitivityX;
    public string horseName;
    public Transform myRideAnchor;
    godScript GOD;
    characterController cC;
    [Header("Taming Stuff")]
    public float tamingGoal, timerDecrease;

    //horse riding movement stuff
    float vert, horiz;
    bool isMoving;
    Vector3 movement;

    // Start is called before the first frame update
    void Start()
    {
        myRideAnchor = transform.Find("Model Parent/RideAnchor");
        GOD = GameObject.Find("GOD").GetComponent<godScript>();
        cC = GameObject.Find("Player").GetComponent<characterController>();
        nav = GetComponent<NavMeshAgent>();
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
            cC.goToGrounded();
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
}
