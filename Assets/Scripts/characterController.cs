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
    Animator anim;
    public GameObject pauseMenu;
    [SerializeField] GameObject[] teleportLocations;
    [SerializeField] Animator physicalHudAnim;

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
        anim = GetComponent<Animator>();
        rb = GetComponent<Rigidbody>();
        myCap = GetComponent<CapsuleCollider>();
        charInt = GetComponent<characterInteract>();
        spinCamGoTo = GameObject.Find("spinnyCam").GetComponent<goToThing>();
        //myMeshRenderer = GetComponentInChildren<SkinnedMeshRenderer>();
    }

    private void Update()
    {
        //heha
        if(isMoving == true && currentState == playerState.GROUNDED)
        {
            anim.speed = 1;
        }
        else
        {
            anim.speed = 0;
        }
        //hahe
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
        if(pauseMenu.activeSelf == false)
        {
            var cameraAngle = cam.transform.rotation.eulerAngles;
            camCurrentX += Input.GetAxis("Mouse Y") * camSensitivityY;
            camCurrentX = Mathf.Clamp(camCurrentX, camMinX, camMaxX);
            cameraAngle.x = camCurrentX;
            cam.transform.rotation = Quaternion.Euler(cameraAngle);
        }

        if (isMoving && currentState == playerState.GROUNDED)
        {
            transform.Translate(movement * moveSpeed * Time.deltaTime);
        }
        if (currentState != playerState.RIDING && currentState != playerState.TAMING)
        {
            if(pauseMenu.activeSelf == false)
            {
                transform.Rotate(new Vector3(0, Input.GetAxis("Mouse X") * camSensitivityX, 0));
            }
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
        if (Input.GetKeyDown(KeyCode.T))
        {
            physicalHudAnim.SetTrigger("teleport");
        }
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
            goToGrounded(new Vector3(-1, 0.5f, 0));
        }
        if (Input.GetKeyDown(KeyCode.T))
        {
            if(charInt.hB.horseInWater == true)
            {
                physicalHudAnim.SetTrigger("teleport");
            }
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

    public void goToGrounded(Vector3 newVector)
    {
        charInt.hB.beingRidden = false;
        rb.constraints = RigidbodyConstraints.FreezeRotation;
        myCap.enabled = true;
        transform.SetParent(null);
        transform.localScale = new Vector3(1, 1, 1);
        transform.position = transform.position + newVector;
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

    public void teleportToStable()
    {
        bool onHorse = false;
        if (currentState == playerState.RIDING)
        {
            onHorse = true;
        }
        float shortestDistance = Mathf.Infinity, dist;
        GameObject selectedTeleporter = new GameObject();
        foreach(GameObject teleporter in teleportLocations)
        {
            dist = Vector3.Distance(transform.position, teleporter.transform.position);
            if(dist < shortestDistance)
            {
                shortestDistance = dist;
                selectedTeleporter = teleporter;
            }
        }
        if(onHorse == false)
        {
            transform.position = selectedTeleporter.transform.position;
        }
        if(onHorse == true)
        {
            charInt.hB.transform.position = selectedTeleporter.transform.position;
        }

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
            myMeshRenderer.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.ShadowsOnly;
            spinCamGoTo.targetToFollow = gameObject;
        }
        if (currentState == playerState.TAMING)
        {
            myMeshRenderer.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.On;
        }
    }
}
