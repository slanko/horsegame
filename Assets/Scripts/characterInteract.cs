using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class characterInteract : MonoBehaviour
{
    float vert, horiz;
    public LayerMask interactableLayers;
    public float interactDistance;
    public Text targetName;
    characterController cC;
    public KeyCode interactKey;
    public horseBehaviour hB;

    //throwing stuff
    [Header ("Throwing Stuff")]
    public Image throwableUI;
    public Sprite nadaSprite;
    public GameObject throwPoint;
    public Animator uiAnim;

    public List<GameObject> heldThrowables;
    // Start is called before the first frame update
    void Start()
    {
        cC = GetComponent<characterController>();
    }

    // Update is called once per frame
    void Update()
    {
        if(cC.currentState == characterController.playerState.GROUNDED || cC.currentState == characterController.playerState.JUMPING)
        {
            if (Physics.Raycast(cC.cam.transform.position, cC.cam.transform.forward, out var rayHit, interactDistance, interactableLayers))
            {
                if (rayHit.collider.gameObject.tag == "horse")
                {
                    hB = rayHit.collider.gameObject.GetComponent<horseBehaviour>();
                    targetName.text = hB.horseName;
                    if (Input.GetKeyDown(interactKey))
                    {
                        transform.position = hB.myRideAnchor.position;
                        transform.SetParent(hB.myRideAnchor);
                        transform.rotation = new Quaternion(0, 0, 0, 0);
                        cC.rb.constraints = RigidbodyConstraints.FreezeAll;
                        cC.myCap.enabled = false;
                        if (hB.isTamed)
                        {
                            cC.goToRide();
                        }
                        else
                        {
                            cC.goToTame();
                        }
                    }
                }
                if(rayHit.collider.gameObject.tag == "throwable")
                {
                    var tS = rayHit.collider.gameObject.GetComponent<throwablesScript>();
                    targetName.text = tS.myName;
                    if (Input.GetKeyDown(interactKey))
                    {
                        heldThrowables.Add(rayHit.collider.gameObject);
                        rayHit.collider.gameObject.SetActive(false);
                    }
                }
            }
            else
            {
                targetName.text = "";
            }
        }
        else
        {
            targetName.text = "";
        }

        if(heldThrowables.Count > 0)
        {
            if (Input.GetKeyDown(cC.throwKey))
            {
                uiAnim.SetTrigger("Throw");
            }
            //set UI image
            throwableUI.sprite = heldThrowables[0].GetComponent<throwablesScript>().myImage;
        }
        else
        {
            throwableUI.sprite = nadaSprite;
        }
    }
    public void actuallyThrow()
    {
        heldThrowables[0].transform.position = throwPoint.transform.position;
        heldThrowables[0].transform.rotation = throwPoint.transform.rotation;
        heldThrowables[0].SetActive(true);
        heldThrowables[0].GetComponent<Rigidbody>().AddForce(throwPoint.transform.forward * 20, ForceMode.Impulse);
        heldThrowables.Remove(heldThrowables[0]);
    }
}
