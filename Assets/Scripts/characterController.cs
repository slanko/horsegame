using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class characterController : MonoBehaviour
{
    public enum playerState
    {
        GROUNDED,
        JUMPING,
        TAMING,
        RIDING,
        RAGDOLL,
        MENU
    }
    public playerState currentState;

    public GameObject cam;
    public float moveSpeed, camSensitivityX, camSensitivityY, vert, horiz;
    bool isMoving;
    Vector3 movement;
    public Rigidbody rb;
    public CapsuleCollider myCap;
    characterInteract charInt;
    public DynamicBone dB;
    public KeyCode tameKey;
    public bool enteredTaming;
    public KeyCode throwKey;

    //ragdoll mode stuff
    [Header ("Ragdoll Mode Variables")]
    goToThing spinCamGoTo;
    public GameObject myRagdoll;
    public SkinnedMeshRenderer myMeshRenderer;

    //camera stuff
    public float camMinX, camMaxX, camCurrentX;

    //debug stuff
    public Text debugText;

    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody>();
        myCap = GetComponent<CapsuleCollider>();
        charInt = GetComponent<characterInteract>();
        spinCamGoTo = GameObject.Find("spinnyCam").GetComponent<goToThing>();
        //myMeshRenderer = GetComponentInChildren<SkinnedMeshRenderer>();
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Alpha1))
        {
            currentState = playerState.GROUNDED;
        }
        if (Input.GetKeyDown(KeyCode.Alpha2))
        {
            currentState = playerState.JUMPING;
        }
        if (Input.GetKeyDown(KeyCode.Alpha3))
        {
            currentState = playerState.TAMING;
        }
        if (Input.GetKeyDown(KeyCode.Alpha4))
        {
            currentState = playerState.RIDING;
        }
        if (Input.GetKeyDown(KeyCode.Alpha5))
        {
            goToRagdoll();
        }

        if (currentState == playerState.GROUNDED)
        {
            updateGrounded();
        }
        if (currentState == playerState.JUMPING)
        {
            updateJumping();
        }
        if (currentState == playerState.TAMING)
        {
            updateTaming();
        }
        if (currentState == playerState.RIDING)
        {
            updateRiding();
        }
        if (currentState == playerState.RAGDOLL)
        {
            updateRagdoll();
        }

        //debug thing
        debugText.text = currentState.ToString();
        //cam stuff

        var cameraAngle = cam.transform.rotation.eulerAngles;
        camCurrentX += Input.GetAxis("Mouse Y") * camSensitivityY;
        camCurrentX = Mathf.Clamp(camCurrentX, camMinX, camMaxX);
        cameraAngle.x = camCurrentX;
        cam.transform.rotation = Quaternion.Euler(cameraAngle);

        if (isMoving && currentState == playerState.GROUNDED)
        {
            transform.Translate(movement * moveSpeed * Time.deltaTime);
        }
        if (currentState != playerState.RIDING && currentState != playerState.TAMING)
        {
            transform.Rotate(new Vector3(0, Input.GetAxis("Mouse X") * camSensitivityX, 0));
        }

    }

    void updateGrounded()
    {
        //movement
        vert = Input.GetAxisRaw("Vertical");
        horiz = Input.GetAxisRaw("Horizontal");
        movement = new Vector3(horiz, 0, vert);
        isMoving = movement.magnitude > 0;
        dB.enabled = false;
    }

    void updateJumping()
    {

    }

    void updateTaming()
    {
        charInt.hB.beingRidden = true;
        dB.enabled = true;
    }

    void updateRiding()
    {
        charInt.hB.beingRidden = true;
        dB.enabled = true;
        if (Input.GetKeyDown(charInt.interactKey))
        {
            goToGrounded();
        }
    }

    void updateRagdoll()
    {

    }

    public void goToTame()
    {
        currentState = playerState.TAMING;
        enteredTaming = false;
    }

    public void goToRide()
    {
        currentState = playerState.RIDING;
    }

    public void goToGrounded()
    {
        charInt.hB.beingRidden = false;
        rb.constraints = RigidbodyConstraints.FreezeRotation;
        myCap.enabled = true;
        transform.SetParent(null);
        transform.localScale = new Vector3(1, 1, 1);
        transform.rotation = new Quaternion(0, transform.rotation.y, 0, 0);
        cam.transform.rotation = new Quaternion(0, 0, 0, 0);
        currentState = playerState.GROUNDED;
    }

    public void goToRagdoll()
    {
        charInt.hB.beingRidden = false;
        currentState = playerState.RAGDOLL;
        GameObject thaRagdoll = Instantiate(myRagdoll, transform.position, transform.rotation, null);
        spinCamGoTo.targetToFollow = thaRagdoll.GetComponent<ragdollLaunchScript>().myHips;
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        //movement and camera
        if (currentState == playerState.RIDING)
        {
            myMeshRenderer.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.ShadowsOnly;
        }
        if (currentState == playerState.RAGDOLL)
        {
            myMeshRenderer.enabled = false;
        }
        if(currentState == playerState.GROUNDED)
        {
            myMeshRenderer.enabled = true;
            myMeshRenderer.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.On;
            spinCamGoTo.targetToFollow = gameObject;
        }
    }
}
