using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class characterController : MonoBehaviour
{
    public GameObject cam;
    public float moveSpeed, camSensitivityX, camSensitivityY, vert, horiz;
    bool isMoving;
    Vector3 movement;
    // Start is called before the first frame update
    void Start()
    {
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
    }

    private void Update()
    {
        //movement
        vert = Input.GetAxisRaw("Vertical");
        horiz = Input.GetAxisRaw("Horizontal");
        movement = new Vector3(horiz, 0, vert);
        isMoving = movement.magnitude > 0;
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        //movement and camera
        transform.Rotate(new Vector3(0, Input.GetAxis("Mouse X") * camSensitivityX, 0));
        cam.transform.Rotate(new Vector3(Input.GetAxis("Mouse Y") * camSensitivityY, 0, 0));
        if (isMoving)
        {
            transform.Translate(movement * moveSpeed * Time.deltaTime);
        }
    }
}
